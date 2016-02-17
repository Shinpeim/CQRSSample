require 'domain/model/worker'
require 'table/workers'
require 'securerandom'

class WorkerRepository
  class << self
    ROLE_MAPPING = {1 => :developer, 2 => :manager}

    def next_id
      SecureRandom.uuid
    end

    def save(worker)
      record = Table::Workers.find_or_create_by(uuid: worker.uuid) do |r|
        r.name = worker.name
        r.role = ROLE_MAPPING.invert[worker.role.symbol]
      end
      build_entity_from_record(record)
    end

    def find(uuid)
      build_entity_from_record(Table::Workers.find_by(uuid: uuid))
    end

    def find_by_name(name)
      record = Table::Workers.find_by(name: name)
      build_entity_from_record(record)
    end

    private
    def build_entity_from_record(record)
      if record
        Worker.new(record.uuid, record.name, ROLE_MAPPING[record.role])
      else
        nil
      end
    end
  end
end

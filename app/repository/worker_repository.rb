require 'domain/model/worker'

class WorkerRepository
  class Table < ActiveRecord::Base
    self.table_name = "workers"
  end

  class << self
    ROLE_MAPPING = {1 => :developer, 2 => :manager}

    def create(name, role)
      record = Table.create(name: name, role: ROLE_MAPPING.invert[role])
      build_entity_from_record(record)
    end

    def find_by_name(name)
      record = Table.find_by(name: name)
      build_entity_from_record(record)
    end

    private
    def build_entity_from_record(record)
      p record
      if record
        Worker.new(record.id, record.name, ROLE_MAPPING[record.role])
      else
        nil
      end
    end
  end
end

require 'domain/model/task'
require 'table/tasks'
require 'securerandom'

class TaskRepository
  class << self
    STATUS_MAPPING = {1 => :opened, 2 => :assigned, 3 => :working, 4 => :reviewing, 5 => :closed}

    def next_id
      SecureRandom.uuid
    end

    def save(task)
      record = Table::Tasks.find_or_create_by(uuid: task.uuid) do |r|
        r.description = task.description
        r.assignee_uuid = task.assignee_uuid
        r.status = STATUS_MAPPING.invert[task.status.symbol]
      end
      build_entity_from_record(record)
    end

    private
    def build_entity_from_record(record)
      if record
        Task.new(record.uuid, record.description, record.assignee_uuid, STATUS_MAPPING[record.status])
      else
        nil
      end
    end
  end
end

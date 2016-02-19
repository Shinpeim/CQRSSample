require 'command'
class Command
  class AssignTask < Command
    attr_reader :task_uuid, :assigner_uuid, :assignee_uuid

    validates_presence_of :assigner_uuid
    validates_presence_of :task_uuid
    validates_presence_of :assignee_uuid

    def initialize(assigner_uuid, task_uuid, assignee_uuid)
      @assigner_uuid = assigner_uuid
      @assignee_uuid = assignee_uuid
      @task_uuid     = task_uuid
    end
  end
end

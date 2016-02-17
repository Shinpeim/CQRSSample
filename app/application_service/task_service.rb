require 'application_service'
require 'application_service/error'
require 'domain/model/task'

class ApplicationService::TaskService
  def initialize(task_repository, worker_repository)
    @task_repository = task_repository
    @worker_repository = worker_repository
  end

  def handleOpenCommand(command)
    if command.invalid?
      raise ApplicationService::ValidationError.new(command.errors.details)
    end

    # 今回はparameterで渡してるけど本来ならログイン済みのsessionなどから取る
    opener = @worker_repository.find(command.opener_uuid)

    assignee =
      if command.assignee_uuid
        @worker_repository.find(command.assignee_uuid)
      else
        nil
      end
    task = Task.open(
      opener,
      @task_repository.next_id,
      command.description,
      assignee
    )
    ActiveRecord::Base.transaction do
      @task_repository.save(task)
    end
  end
end

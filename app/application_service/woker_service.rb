require 'application_service'
require 'application_service/error'

class ApplicationService::WorkerService
  def initialize(repository)
    @repository = repository
  end

  # applciation service では Commandを引数に取り、
  def handleCreateCommand(command)

    # 入力の妥当性をチェックし
    if command.invalid?
      raise ApplicationService::ValidationError.new(command.errors.details)
    end

    # コマンドに応じてrepositoryやentityを操作する
    ActiveRecord::Base.transaction do
      @repository.create(command.name, command.role_as_symbol)
    end
  end
end

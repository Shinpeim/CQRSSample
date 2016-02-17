require 'bundler'
Bundler.require

base_dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.push(File.join(base_dir, "app"))

require 'yaml'

db_config = YAML.load_file(File.join(base_dir, 'db', 'config.yml'))
db_config["database"] = "db/" + db_config["database"]
ActiveRecord::Base.establish_connection(db_config)

require 'sinatra'

require 'command/create_worker'
require 'application_service/woker_service'
require 'repository/worker_repository'
post '/workers' do
  repository = WorkerRepository
  command = Command::CreateWorker.new(
    params["name"],
    params["role"],
    repository
  )
  service = ApplicationService::WorkerService.new(repository)

  # todo: presentation layer に切り出す
  begin
    service.handleCreateCommand(command)
    {}.to_json
  rescue ApplicationService::ValidationError => e
    status 400
    e.details.to_json
  end
end

require 'read_layer/show_workers'
get '/workers' do
  page =
    if params['page'].to_i < 1
      1
    else
      params['page'].to_i
    end
  ReadLayer::ShowWorkers.list(page).to_json
end

require 'command/open_task'
require 'application_service/task_service'
require 'repository/task_repository'
post '/tasks' do
  command = Command::OpenTask.new(
    params["opener_uuid"],
    params["description"],
    params["assignee_uuid"],
  )

  service = ApplicationService::TaskService.new(TaskRepository, WorkerRepository)

  begin
    service.handleOpenCommand(command)
    {}.to_json
  rescue ApplicationService::ValidationError => e
    status 400
    e.details.to_json
  end
end

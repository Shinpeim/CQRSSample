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

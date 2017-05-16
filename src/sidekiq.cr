require "./scnu/task/judge"
require "./scnu/model/*"
require "./scnu/config/*"
require "sidekiq/cli"
cli = Sidekiq::CLI.new
server = cli.configure do |config|
  # middleware would be added here
end

cli.run(server)

# This file allows apps to require "sidekiq/web" instead of "sidekiq/sidekiq/web".
require "./sidekiq/web"

Session.config.secret = "my_super_secret"

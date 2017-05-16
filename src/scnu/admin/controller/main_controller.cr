module Admin::MainController
  include Admin::Common
  extend self

  def home(env)
    admin "main/home", "后台首页"
  end
end

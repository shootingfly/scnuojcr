module LayoutController
  include Common
  extend self

  macro redirect_back
    if env.request.headers["Referer"]?
      env.redirect env.request.headers["Referer"]
    else
      env.redirect "/"
    end
  end

  def set_theme(env)
    theme = env.params.body["theme"].as(String)
    env.response.cookies << HTTP::Cookie.new("theme", theme)
    redirect_back
  end

  def set_locale(env)
    if env.request.cookies["locale"]?.try &.value == "en"
      env.response.cookies << HTTP::Cookie.new("locale", "zh-cn")
    else
      env.response.cookies << HTTP::Cookie.new("locale", "en")
    end
    redirect_back
  end
end

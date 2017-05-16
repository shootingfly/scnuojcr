require "i18n"

class HTTP::Server::Context
  include I18n

  def locale
    self.request.cookies["locale"]?.try &.value || "en"
  end
end

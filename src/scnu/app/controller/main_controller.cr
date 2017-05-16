require "markdown"

module MainController
  include Common
  extend self

  def home(env)
    view "main/home", t(Home)
  end

  def faq(env)
    faq = Markdown.to_html(File.read("public/faq.md"))
    view "main/faq", t(FAQ)
  end

  def about(env)
    view "main/about", t(About)
  end

  def joinus(env)
    view "main/joinus", t(Joinus)
  end
end

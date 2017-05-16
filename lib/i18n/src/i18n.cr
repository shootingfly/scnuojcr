require "yaml"

module I18n
  LANGS        = %w(en zh-cn)
  LOCALE_PATHS = ["/home/rocky/Crystals/scnu/src/scnu/config/locales"]

  macro included
    @@strings = {} of String => Hash(String, String)
    {% for lang in LANGS %}
        @@strings[{{lang}}] = text = Hash(String, String).new
      {% for path in LOCALE_PATHS %}
        paths = {{"#{path.id}/#{lang.id}.yml"}}
        io = {{ system("cat #{path.id}/#{lang.id}.yml 2>/dev/null || true").stringify }}
        h = YAML.parse(io)
        h = h[{{lang}}].as_h
        h.each do |k, v|
          text[k.as(String)] = v.as(String)
        end
      {% end %}
    {% end %}
  end

  def locale
    begin
      locale = "en"
      languages = request.headers["Accept-Language"]? || "en"
      languages.downcase.split(",").each do |lang|
        next if lang == "*"
        lang = lang.split(";")[0]
        break locale = lang if @@strings[lang]?
      end
      locale
    end
  end

  def get_locale
    @@strings[locale]
  end

  def t(msg, options = {} of String => String)
    string = get_locale[msg]? || msg
    if options.empty?
      string
    else
      string % options
    end
  end
end

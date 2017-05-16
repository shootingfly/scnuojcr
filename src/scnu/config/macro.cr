macro admin_view(filename, title, flash = "")
	page_title = {{title}}
	flash = {{ flash }}
	render "src/Admins/views/#{{{filename}}}.ecr", "src/Layouts/admin.ecr"
end

macro t(h)
	env.t("{{h}}")
end

macro redirect_back
	if env.session.string?("return_to")
		env.redirect env.session.string("return_to")
	else
		env.redirect env.request.headers["Referer"]
	end
end

macro body
	env.params.body
end

macro url
	env.params.url
end

macro query
	env.params.query
end

macro json
	env.params.json
end

macro redirect(path)
	env.redirect {{path}}
end

macro session
	env.session
end

macro cookie(string)
	env.request.cookies[{{string}}]?.try &.value
end

macro cookie?(string)
	env.request.cookies.has_key?({{string}})
end

macro cookie(key, string)
	env.response.cookies << HTTP::Cookie.new({{key}}, {{string}}.as(String))
end

macro cookie_del(key)
	env.response.cookies << HTTP::Cookie.new({{key}}, "", expires: Time.now)
end

class Object
  macro def methods : Array(Symbol)
    {{ @type.methods.map { |x| %(:"#{x.name}").id } }}
  end
end

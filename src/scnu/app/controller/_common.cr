require "i18n"

module Common
  include I18n

  macro view(filename, page_title)
    page_title = {{page_title}}
    puts "#{__DIR__}"
    render "src/scnu/app/view/#{{{filename}}}.ecr", "src/scnu/layout/app.ecr"
  end

  macro view(filename)
    render "src/scnu/app/view/#{{{filename}}}.ecr", "src/scnu/layout/app.ecr"
  end

  macro contest_view(filename, page_title)
    page_title = {{page_title}}
    render "src/scnu/app/view/#{{{filename}}}.ecr", "src/scnu/layout/contest.ecr"
  end

  macro contest_view(filename)
    render "src/scnu/app/view/#{{{filename}}}.ecr", "src/scnu/layout/contest.ecr"
  end

  macro current_user
    User.query("select * from User where id = (select user_id from UserLogin where auth_token = '#{cookie("auth_token")}')")[0]
    # UserLogin.find(auth_token: cookie("auth_token"))
  end

  macro datatable(model, where = false)
    draw = env.params.query["draw"]
    start = env.params.query["start"]
    length = env.params.query["length"]
    search_value = env.params.query["search[value]"]
    {% if where %}
      total = {{model}}.count({{where}}).as(Int64)
    {% else %}
      total = {{model}}.count.as(Int64)
    {% end %}
    records = {{model}}.query("select * from #{{{model}}} #{{{model.stringify.downcase.id}}_search} #{{{model.stringify.downcase.id}}_order} limit #{start},#{length}")
    if search_value == ""
      filter = total
    else
      filter = {{model}}.scalar("select count(1) from #{{{model}}} #{{{model.stringify.downcase.id}}_search}").as(Int64)
    end
    {
      data: {{model.stringify.downcase.id}}_data,
      recordsTotal:    total,
      recordsFiltered: filter,
      draw:            draw,
    }.to_json
  end

  macro current_theme
    cookie("theme")|| DEFAULT_THEME
  end

  macro current_locale
    cookie("locale")|| DEFAULT_LOCALE
  end

  macro current_code_theme
    cookie("code_theme") || DEFAULT_CODE_THEME
  end

  macro current_keymap
    cookie("keymap") || DEFAULT_KEYMAP
  end

  macro current_mode
    cookie("mode") || DEFAULT_MODE
  end
end

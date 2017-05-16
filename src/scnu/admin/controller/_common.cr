require "secure_random"

module Admin::Common
  macro admin(filename, page_title)
    page_title = {{page_title}}
    render "src/scnu/admin/view/#{{{filename}}}.ecr", "src/scnu/layout/admin.ecr"
  end

  macro admin(filename)
    render "src/scnu/admin/view/#{{{filename}}}.ecr", "src/scnu/layout/admin.ecr"
  end

  macro current_user
    User.first[0]
  end

  macro redirect_back
    env.redirect "/"
  end

  macro datatable(model)
    draw = env.params.query["draw"]
    start = env.params.query["start"]
    length = env.params.query["length"]
    search_value = env.params.query["search[value]"]
    total = {{model}}.count.as(Int64)
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
    env.request.cookies["theme"]?.try &.value || "cosmo"
  end

  def generate_token
    SecureRandom.base64
  end
end

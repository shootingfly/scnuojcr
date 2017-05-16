module StatusController
  include Common
  extend self

  macro status_data
    if cookie?("auth_token")
      student_id = current_user.student_id
    else
      student_id = 0
    end
    records.map do |status|
      [
        render_flag(student_id, status.student_id),
        status.id,
        %(<a href="/user/#{status.student_id}">#{status.username}</a>),
        %(<a href="/problem_id/#{status.problem_id}">#{status.problem_id}</a>),
        render_result,
        "#{status.time_cost} ms",
        "#{status.space_cost} kb",
        status.language,
        status.created_at.to_s("%m-%d %H:%M:%S"),
      ]
    end
  end

  macro render_flag(id1, id2)
    if {{id1}} == {{id2}}
      %(<img src="/image/Check_mark.png" witdh="16" height="16"/>)
    else
      ""
    end
  end

  macro render_result
    case status.result
    when AC
      %(<label class="text-success">#{status.result}</label>)
    when CE, RE
      %(<a href="/status/#{status.id}/error">#{status.result}</a>)
    when WA
      %(<label class="text-danger">#{status.result}</label>)
    else
      %(<label class="text-warning">#{status.result}</label>)
    end
  end

  macro status_search
    %(where id like '%#{search_value}%' or username like '%#{search_value}%' or problem_id like '%#{search_value}%' or result like '%#{search_value}%')
  end

  macro status_order
    %(order by id desc)
  end

  def index(env)
    if env.params.query["draw"]?
      datatable Status
    else
      view "status/index", t(Status)
    end
  end

  def error(env)
    status = Status.find(env.params.url["id"].to_i)
    error = Markdown.to_html(File.read("#{ERROR_PATH}/#{status.error}.err"))
    view "status/error", t(ErrorDetail)
  end
end

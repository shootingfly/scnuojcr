module ContestController
  include Common
  extend self

  macro contest_data
    records.map do |contest|
      [
        contest.id,
        %(<a href="/contest/#{contest.id}" target="_blank">#{contest.title}</a>),
        contest.start_time.to_s("%Y-%m-%d %H:%M"),
        contest.end_time.to_s("%Y-%m-%d %H:%M"),
        contest.address,
        contest.status,
        contest.remark
      ]
    end
  end

  macro contest_search
    %(where title like '%#{search_value}%')
  end

  macro contest_order
    %(order by id desc)
  end

  def index(env)
    if env.params.query["draw"]?
      datatable Contest
    else
      view "contest/index", t(Contest)
    end
  end

  def show(env)
    contest = Contest.find(env.params.url["id"].to_i)
    page_title = contest.title
    contest_view "contest/show"
  end

  macro contestproblem_data
    records.map do |problem|
      [
        problem.id,
        %(<a href="/contest/#{problem.contest_id}/problem/#{problem.problem_id}">#{problem.problem_id}</a>),
        %(<a href="/contest/#{problem.contest_id}/problem/#{problem.problem_id}">#{problem.title}</a>),
        problem.ac,
        problem.submit
      ]
    end
  end

  macro contestproblem_search
    %(where (contest_id = #{env.params.url["id"]}) and (problem_id like '%#{search_value}%' or title like '%#{search_value}%'))
  end

  macro contestproblem_order
    %(order by ac desc)
  end

  def problem(env)
    if env.params.query["draw"]?
      datatable ContestProblem, "where contest_id = #{env.params.url["id"]}"
    else
      contest = Contest.find(env.params.url["id"].to_i)
      contest_view "contest/problem", t(ContestProblem)
    end
  end

  macro conteststatus_data
    records.map do |status|
      [
        status.id,
        %(<a href="/user/#{status.student_id}">#{status.username}</a>),
        %(<a href="/contest/#{status.contest_id}/problem/#{status.problem_id}">#{status.problem_id}</a>),
        status.result,
        status.time_cost,
        status.space_cost,
        status.language,
        status.created_at.to_s("%Y-%m-%d %T")
      ]
    end
  end

  macro conteststatus_search
    %(where (contest_id = #{env.params.url["id"]}) and (username like '%#{search_value}%' or problem_id like '%#{search_value}%' or result like '%#{search_value}%'))
  end

  macro conteststatus_order
    %(order by id desc)
  end

  def status(env)
    if env.params.query["draw"]?
      datatable ContestStatus, "where contest_id = #{env.params.url["id"]}"
    else
      contest = Contest.find(env.params.url["id"].to_i)
      contest_view "contest/status", t(ContestStatus)
    end
  end

  macro contestrank_data
    rank_id = env.params.query["start"].as(String).to_i
    records.map do |rank|
      [
        rank_id += 1,
        %(<a href="/user/#{rank.student_id}">#{rank.username}</a>),
        rank.ac,
        rank.penalty,
        rank.details
      ]
    end
  end

  macro contestrank_search
    %(where (contest_id = #{env.params.url["id"]}) and (username like '%#{search_value}%'))
  end

  macro contestrank_order
    %(order by ac desc)
  end

  def rank(env)
    if env.params.query["draw"]?
      datatable ContestRank, "where contest_id = #{env.params.url["id"]}"
    else
      contest = Contest.find(env.params.url["id"].to_i)
      contest_view "contest/rank", t(ContestRank)
    end
  end
end

module Admin::ContestController
  include Admin::Common
  extend self

  macro contest_data
    records.map do |contest|
      [
        contest.id,
        %(<a href="/contest/#{contest.id}" target="_blank">#{contest.title}</a>),
        contest.start_time.to_s("%Y-%m-%d %T"),
        contest.end_time.to_s("%Y-%m-%d %T"),
        contest.address,
        contest.status,
        contest.remark,
        %(<a href="/contest/#{contest.id}" class="btn btn-info btn-xs" target="_blank">查看</a>
        <a href="/admin/contest/#{contest.id}/edit" class="btn btn-warning btn-xs">编辑</a>
        <a href="/delete/contest/#{contest.id}" onclick="if(confirm('Are U Sure?') == false) return false;" class="btn btn-danger btn-xs">删除</a>)
      ]
    end
  end

  macro contest_search
    %(where id like '%#{search_value}%' or title like '%#{search_value}%')
  end

  macro contest_order
    %(order by id desc)
  end

  def index(env)
    if env.params.query["draw"]?
      datatable Contest
    else
      admin "contest/index", "比赛列表"
    end
  end

  def create(env)
    admin "contest/new", "新增比赛"
  end

  def create_post(env)
    Contest.insert(
      title: env.params.body["title"],
      start_time: env.params.body["start_time"],
      end_time: env.params.body["end_time"],
      address: env.params.body["address"],
      status: env.params.body["status"],
      remark: env.params.body["remark"]
    )
    env.redirect "/admin/contest/new"
  end

  def update(env)
    contest = Contest.find(env.params.url["id"].to_i)
    admin "contest/edit", "更新比赛"
  end

  def update_post(env)
    Contest.update(env.params.url["id"].to_i,
      title: env.params.body["title"],
      start_time: env.params.body["start_time"],
      end_time: env.params.body["end_time"],
      address: env.params.body["address"],
      status: env.params.body["status"],
      remark: env.params.body["remark"]
    )
    env.redirect "/admin/contest"
  end

  def delete(env)
    Contest.delete(env.params.url["id"].to_i)
    env.redirect "/admin/contest"
  end
end

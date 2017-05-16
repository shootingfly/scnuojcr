module RankController
  include Common
  extend self

  macro user_data
    rank = env.params.query["start"].as(String).to_i
    records.map do |user|
      [
        rank += 1,
        %(<a href="/user/#{user.student_id}">#{user.username}</a>),
        user.dormitory,
        user.classgrade,
        user.score
      ]
    end
  end

  macro user_search
    %(where username like '%#{search_value}%' or dormitory like '%#{search_value}%' or classgrade like '%#{search_value}%')
  end

  macro user_order
    %(order by score desc)
  end

  def index(env)
    if env.params.query["draw"]?
      datatable User
    else
      view "rank/index", t(Rank)
    end
  end

  macro rank_data
    records.map do |rank|
      [
        rank.week_rank,
        %(<a href="/user/#{rank.student_id}">#{rank.username}</a>),
        rank.week_score
      ]
    end
  end

  macro rank_search
    %(where username like '%#{search_value}%' or classgrade like '%#{search_value}%')
  end

  macro rank_order
    %(order by week_rank asc)
  end

  def week(env)
    if env.params.query["draw"]?
      datatable Rank
    else
      view "rank/week", t(WeekRank)
    end
  end
end

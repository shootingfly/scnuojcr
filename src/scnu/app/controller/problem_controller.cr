module ProblemController
  include Common
  extend self

  def index(env)
    if env.params.query["draw"]?
      datatable Problem
    else
      view "problem/index", t(Problem)
    end
  end

  macro problem_data
    records.map do |problem|
      [
        %(<a href="/problem/#{problem.problem_id}">#{problem.problem_id}</a>),
        %(<a href="/problem/#{problem.problem_id}">#{problem.title}</a>),
        problem.difficulty,
        "#{problem.ac/problem.submit} (#{problem.ac}/#{problem.submit})",
        problem.source,
      ]
    end
  end

  macro problem_search
    %(where problem_id like '%#{search_value}%' or title like '%#{search_value}%' or zh_title like '%#{search_value}%' or difficulty like '%#{search_value}%')
  end

  macro problem_order
    %(order by problem_id asc)
  end

  def show(env)
    problem = Problem.find(problem_id: env.params.url["problem_id"])
    description = Markdown.to_html(File.read(problem.description))
    view "problem/show", t(ProblemShow)
  end

  def rand(env)
    problem = Problem.rand[0]
    env.redirect "/problem/#{problem.problem_id}"
  end

  def prev(env)
    problem = Problem.where("where problem_id < #{env.params.url["problem_id"]} order by problem_id desc limit 1")[0]
    env.redirect "/problem/#{problem.problem_id}"
  end

  def next(env)
    problem = Problem.where("where problem_id > #{env.params.url["problem_id"]} order by problem_id asc limit 1")[0]
    env.redirect "/problem/#{problem.problem_id}"
  end

  def judge(env)
    problem = Problem.find(problem_id: env.params.url["problem_id"])
    view "problem/judge", t(ProblemJudge)
  end

  def judge_post(env)
    code = File.read("/home/rocky/Crystals/scnu/public/judge/code/1000.c")
    Judge.async.perform(code, "C", 423, 1)
    env.redirect "/status"
  end

  def judge_test(env)
    code = File.read("/home/rocky/Crystals/scnu/public/judge/code/1000.c")
    Judge.async.perform(code, "C", 423, 1)
    env.redirect "/status"
  end

  def comment(env)
    comments = ProblemComment.where("where problem_id = #{env.params.url["problem_id"]} order by id desc")
    view "problem/comment", t(ProblemComment)
  end

  def comment_post(env)
    ProblemComment.insert(
      problem_id: env.params.body["problem_id"],
      student_id: env.params.body["student_id"],
      content: env.params.body["content"]
    )
    env.redirect "/problem/#{env.params.body["problem_id"]}/comment"
  end

  def detail(env)
    # pd = ProblemDetail.first[0]
    # result = AC
    # str = HASH[result]
    # ProblemDetail.update(1,
    #   submit: pd.submit + 1,
    #   ac: pd.ac + str.bit(0),
    #   re: pd.re + str.bit(1),
    #   te: pd.te + str.bit(2),
    #   me: pd.me + str.bit(3),
    #   oe: pd.oe + str.bit(4),
    #   wa: pd.wa + str.bit(5),
    #   pe: pd.pe + str.bit(6)
    # )
  end
end

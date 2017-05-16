module Admin::ProblemController
  include Admin::Common
  extend self

  macro problem_data
    records.map do |problem|
      [
        problem.id,
        %(<a href="/problem/#{problem.problem_id}" target="_blank">#{problem.problem_id}</a>),
        %(<a href="/problem/#{problem.problem_id}" target="_blank">#{problem.title}</a>),
        problem.difficulty,
        "#{problem.ac/problem.submit rescue 0} (#{problem.ac}/#{problem.submit})",
        problem.source,
        %(<a href="/problem/#{problem.problem_id}" class="btn btn-info btn-xs" target="_blank">查看</a>
        <a href="/admin/problem/#{problem.problem_id}/edit" class="btn btn-warning btn-xs">编辑</a>
        <a href="/delete/problem/#{problem.id}" onclick="if(confirm('Are U Sure?') == false) return false;" class="btn btn-danger btn-xs">删除</a>)
      ]
    end
  end

  macro problem_search
    %(where problem_id like '%#{search_value}%' or title like '%#{search_value}%' or zh_title like '%#{search_value}%' or difficulty like '%#{search_value}%')
  end

  macro problem_order
    %(order by problem_id asc)
  end

  def index(env)
    if env.params.query["draw"]?
      datatable Problem
    else
      admin "problem/index", "题目管理"
    end
  end

  def create(env)
    admin "problem/new", "新建题目"
  end

  def create_post(env)
    description = file_upload(env, "description", "upload/problem/description")
    testdata = file_upload(env, "testdata", "upload/problem/testdata")
    zh_description = file_upload(env, "zh_description", "upload/problem/zh_description")
    Problem.insert(
      problem_id: env.params.body["problem_id"],
      title: env.params.body["title"],
      difficulty: env.params.body["difficulty"],
      time: env.params.body["time"],
      space: env.params.body["space"],
      ac: 0,
      submit: 0,
      source: "SCNUOJ",
      description: description,
      testdata: testdata,
      zh_title: env.params.body["zh_title"],
      zh_description: zh_description
    )
    env.redirect "/admin/problem/new"
  end

  def edit(env)
    problem = Problem.find(problem_id: env.params.url["problem_id"])
    admin "problem/edit", "编辑题目"
  end

  def update(env)
    problem = Problem.find(problem_id: env.params.body["problem_id"])
    description = file_upload(env, "description", "upload/problem/description")
    testdata = file_upload(env, "testdata", "upload/problem/testdata")
    zh_description = file_upload(env, "zh_description", "upload/problem/zh_description")
    Problem.update(problem.id,
      problem_id: env.params.body["problem_id"],
      title: env.params.body["title"],
      difficulty: env.params.body["difficulty"],
      time: env.params.body["time"],
      space: env.params.body["space"],
      description: description,
      testdata: testdata,
      zh_title: env.params.body["zh_title"],
      zh_description: zh_description
    )
    env.redirect "/problem/#{env.params.body["problem_id"]}"
  end

  def delete(env)
    Problem.delete(env.params.url["id"].to_i)
    env.redirect "/admin/problem"
  end

  def file_upload(env, name, store_dir) : String
    file = env.params.files[name]
    if file.filename == ""
      ""
    else
      file_path = "#{Kemal.config.public_folder}/#{store_dir}/#{file.filename}"
      File.open(file_path, "w") do |f|
        IO.copy(file.tmpfile, f)
      end
      file_path
    end
  end
end

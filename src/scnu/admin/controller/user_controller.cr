module Admin::UserController
  include Admin::Common
  extend self

  macro user_data
    records.map do |user|
      [
        user.student_id,
        user.username,
        user.dormitory,
        user.classgrade,
        user.phone,
        %(<a href="/user/#{user.student_id}" class="btn btn-info btn-xs" target="_blank">查看</a>
        <a href="/admin/user/#{user.student_id}/edit" class="btn btn-warning btn-xs">编辑</a>)
      ]
    end
  end

  macro user_search
    %(where student_id like '%#{search_value}%' or dormitory like '%#{search_value}%' or classgrade like '%#{search_value}%')
  end

  macro user_order
    %(order by student_id desc)
  end

  def index(env)
    if env.params.query["draw"]?
      datatable User
    else
      admin "user/index", "用户列表"
    end
  end

  def create(env)
    admin "user/new", "新增用户"
  end

  def create_post(env)
    User.insert(
      student_id: env.params.body["student_id"],
      username: env.params.body["username"],
      dormitory: env.params.body["dormitory"],
      classgrade: env.params.body["classgrade"],
      phone: env.params.body["phone"],
      qq: env.params.body["qq"],
      signature: env.params.body["signature"],
      avatar: "",
      score: 0,
      rank: 9999
    )
    env.redirect "/admin/user/new"
  end

  def update(env)
    user = User.find(student_id: env.params.url["student_id"])
    admin "user/edit", "编辑用户"
  end

  def update_post(env)
    user = User.find(student_id: env.params.url["student_id"])
    User.update(user.id,
      student_id: env.params.body["student_id"],
      username: env.params.body["username"],
      dormitory: env.params.body["dormitory"],
      classgrade: env.params.body["classgrade"],
      phone: env.params.body["phone"],
      qq: env.params.body["qq"],
      signature: env.params.body["signature"],
    )
    env.redirect "/admin/user"
  end
end

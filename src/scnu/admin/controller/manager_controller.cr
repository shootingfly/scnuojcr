module Admin::ManagerController
  include Admin::Common
  extend self

  macro manager_data
    records.map do |manager|
      [
        manager.id,
        manager.username,
        manager.role,
        manager.remark,
        %(<a href="/admin/manager/#{manager.id}/edit" class="btn btn-warning btn-xs">编辑</a>
        <a href="/delete/manager/#{manager.id}" class="btn btn-danger btn-xs" onclick="if(confirm('Are U Sure') == false) return false;">删除</a>)
      ]
    end
  end

  macro manager_search
    %(where username like '%#{search_value}%')
  end

  macro manager_order
    %(order by created_at desc)
  end

  def index(env)
    if env.params.query["draw"]?
      datatable Manager
    else
      admin "manager/index", "管理员列表"
    end
  end

  def create(env)
    admin "manager/new", "新建管理员"
  end

  def create_post(env)
    Manager.insert(
      username: env.params.body["username"],
      password: env.params.body["password"],
      role: env.params.body["role"],
      remark: env.params.body["remark"],
      token: generate_token
    )
    env.redirect "/admin/manager/new"
  end

  def update(env)
    manager = Manager.find(env.params.url["id"].to_i)
    admin "manager/edit", "编辑管理员"
  end

  def update_post(env)
    Manager.update(env.params.url["id"].to_i,
      username: env.params.body["username"],
      password: env.params.body["password"],
      role: env.params.body["role"],
      remark: env.params.body["remark"]
    )
    env.redirect "/admin/manager"
  end

  def delete(env)
    Manager.delete(env.params.url["id"].to_i)
    env.redirect "/admin/manager"
  end
end

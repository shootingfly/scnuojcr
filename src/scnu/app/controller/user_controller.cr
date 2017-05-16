module UserController
  include Common
  extend self

  def login(env)
    if env.request.headers["Referer"]? && !(env.request.headers["Referer"] =~ /login|register/)
      env.session.string("return_to", env.request.headers["Referer"])
    end
    flash = env.params.query["ret"]?
    view "user/login", t(Login)
  end

  def login_post(env)
    user = UserLogin.find?(student_id: env.params.body["student_id"])
    if user.nil?
      env.redirect "/login?ret=用户名错误"
    elsif user.password != env.params.body["password"]
      env.redirect "/login?ret=密码错误"
    else
      env.response.cookies << HTTP::Cookie.new("auth_token", user.auth_token, http_only: true)
      redirect_back
    end
  end

  def register(env)
    if env.request.headers["Referer"]? && !(env.request.headers["Referer"] =~ /login|register/)
      env.session.string("return_to", env.request.headers["Referer"])
    end
    flash = env.params.query["ret"]?
    view "user/register", t(Register)
  end

  def register_post(env)
    user = User.find?(student_id: env.params.body["student_id"])
    if user.nil?
      User.insert(
        student_id: env.params.body["student_id"],
        username: env.params.body["username"],
        classgrade: env.params.body["classgrade"],
        dormitory: env.params.body["dormitory"],
        phone: env.params.body["phone"],
        signature: env.params.body["signature"],
        avatar: generate_avatar(env.params.body["qq"]),
        qq: env.params.body["qq"],
        score: 0,
        rank: 9999
      )
      user = User.find(student_id: env.params.body["student_id"])
      auth_token = SecureRandom.base64
      UserLogin.insert(
        user_id: user.id,
        student_id: env.params.body["student_id"],
        password: env.params.body["password"],
        auth_token: auth_token
      )
      UserProfile.insert(
        user_id: user.id,
        theme: DEFAULT_THEME,
        locale: DEFAULT_LOCALE,
        mode: DEFAULT_MODE,
        keymap: DEFAULT_KEYMAP,
        code_theme: DEFAULT_CODE_THEME
      )
      UserDetail.insert(
        user_id: user.id,
        ac: 0,
        submit: 0,
        wa: 0,
        pe: 0,
        re: 0,
        ce: 0,
        te: 0,
        me: 0,
        oe: 0,
        ac_records: "",
        contest_records: ""
      )
      env.response.cookies << HTTP::Cookie.new("auth_token", auth_token, http_only: true)
      redirect_back
    else
      env.redirect "/register?ret=账号已存在"
    end
  end

  def logout(env)
    env.session.destroy
    cookie_del("auth_token")
    redirect_back
  end

  def profile(env)
    view "user/profile", t(Profile)
  end

  def profile_post(env)
    cookie("theme", env.params.body["theme"])
    cookie("locale", env.params.body["locale"])
    cookie("mode", env.params.body["mode"])
    cookie("keymap", env.params.body["keymap"])
    cookie("code_theme", env.params.body["code_theme"])
    UserProfile.update(current_user.id,
      theme: env.params.body["theme"],
      locale: env.params.body["locale"],
      mode: env.params.body["mode"],
      keymap: env.params.body["keymap"],
      code_theme: env.params.body["code_theme"]
    )
    redirect_back
  end

  def show(env)
    user = User.find(student_id: env.params.url["student_id"])
    user_detail = UserDetail.find(user_id: user.id)
    view "user/show", t(UserInfo)
  end

  def info(env)
    user = current_user
    user_detail = UserDetail.find(user_id: user.id)
    view "user/show", t(UserInfo)
  end

  def update(env)
    user = current_user
    view "user/info", t(UserEdit)
  end

  def update_post(env)
    User.update(current_user.id,
      username: env.params.body["username"],
      dormitory: env.params.body["dormitory"],
      phone: env.params.body["phone"],
      qq: env.params.body["qq"],
      signature: env.params.body["signature"],
    )
    redirect_back
  end

  def password(env)
  end

  def password_post(env)
  end

  def solution(env)
    user = User.find(student_id: env.params.url["student_id"])
    problem_id = env.params.url["problem_id"]
    student_id = env.params.url["student_id"]
    solutions = Markdown.to_html(File.read("#{SOLUTION_PATH}/#{student_id}.md"))
    view "user/solution", t(UserSolution)
  end
end

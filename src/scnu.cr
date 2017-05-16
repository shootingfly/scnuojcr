require "kemal"
require "kemal-session"
require "./scnu/**"
get "/" { |e| MainController.home e }
get "/about" { |e| MainController.about e }
get "/faq" { |e| MainController.faq e }
get "/joinus" { |e| MainController.joinus e }
get "/login" { |e| UserController.login e }
post "/login" { |e| UserController.login_post e }
get "/register" { |e| UserController.register e }
post "/register" { |e| UserController.register_post e }
post "/set_theme" { |e| LayoutController.set_theme e }
get "/set_locale" { |e| LayoutController.set_locale e }
get "/problem" { |e| ProblemController.index e }
get "/problem/:problem_id" { |e| ProblemController.show e }
get "/problem/:problem_id/comment" { |e| ProblemController.comment e }
post "/problem/:problem_id/comment" { |e| ProblemController.comment_post e }
get "/problem/:problem_id/judge" { |e| ProblemController.judge e }
get "/problem/:problem_id/test" { |e| ProblemController.judge_test e }
post "/problem/:problem_id/judge" { |e| ProblemController.judge_post e }
get "/problem/:problem_id/prev" { |e| ProblemController.prev e }
get "/problem/:problem_id/next" { |e| ProblemController.next e }
get "/problem/:problem_id/rand" { |e| ProblemController.rand e }
get "/rank" { |e| RankController.index e }
get "/rank/week" { |e| RankController.week e }
get "/status" { |e| StatusController.index e }
get "/status/:id/error" { |e| StatusController.error e }
get "/contest" { |e| ContestController.index e }
get "/contest/:id" { |e| ContestController.show e }
get "/contest/:id/problem" { |e| ContestController.problem e }
get "/contest/:id/status" { |e| ContestController.status e }
get "/contest/:id/rank" { |e| ContestController.rank e }

get "/user/profile" { |e| UserController.profile e }
post "/user/profile" { |e| UserController.profile_post e }
get "/user/:student_id" { |e| UserController.show e }
get "/user/info" { |e| UserController.info e }
get "/user/edit" { |e| UserController.update e }
post "/user/edit" { |e| UserController.update_post e }
get "/user/password" { |e| UserController.password e }
get "/user/:student_id/solution/:problem_id" { |e| UserController.solution e }
post "/user/password" { |e| UserController.password_post e }
get "/logout" { |e| UserController.logout e }

get "/admin" { |e| Admin::MainController.home e }
get "/admin/problem" { |e| Admin::ProblemController.index e }
get "/admin/problem/new" { |e| Admin::ProblemController.create e }
post "/admin/problem/new" { |e| Admin::ProblemController.create_post e }
get "/admin/problem/:problem_id/edit" { |e| Admin::ProblemController.edit e }
post "/admin/problem/:problem_id/edit" { |e| Admin::ProblemController.update e }
get "/delete/problem/:id" { |e| Admin::ProblemController.delete e }

get "/admin/user" { |e| Admin::UserController.index e }
get "/admin/user/new" { |e| Admin::UserController.create e }
post "/admin/user/new" { |e| Admin::UserController.create_post e }
get "/admin/user/:student_id/edit" { |e| Admin::UserController.update e }
post "/admin/user/:student_id/edit" { |e| Admin::UserController.update_post e }

get "/admin/contest" { |e| Admin::ContestController.index e }
get "/admin/contest/new" { |e| Admin::ContestController.create e }
post "/admin/contest/new" { |e| Admin::ContestController.create_post e }
get "/admin/contest/:id/edit" { |e| Admin::ContestController.update e }
post "/admin/contest/:id/edit" { |e| Admin::ContestController.update_post e }
get "/delete/contest/:id" { |e| Admin::ContestController.delete e }

get "/admin/manager" { |e| Admin::ManagerController.index e }
get "/admin/manager/new" { |e| Admin::ManagerController.create e }
post "/admin/manager/new" { |e| Admin::ManagerController.create_post e }
get "/admin/manager/:id/edit" { |e| Admin::ManagerController.update e }
post "/admin/manager/:id/edit" { |e| Admin::ManagerController.update_post e }
get "/delete/manager/:id" { |e| Admin::ManagerController.delete e }
get "/problem/detail" { |e| ProblemController.detail e }

Sidekiq::Client.default_context = Sidekiq::Client::Context.new

Kemal.run(4000)

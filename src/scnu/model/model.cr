require "orm"

# DB_URL = "mysql://rocky@localhost/shop?initial_pool_size=10&&max_idle_pool_size=10
DB_URL = "mysql://rocky@localhost/scnu"
table(Problem, problem_id: Int32, title: String, description: String, source: String, difficulty: Int32, ac: Int32, submit: Int32, ratio: Float32, testdata: String, time: Int32, space: Int32, zh_title: String, zh_description: String)
table(ProblemComment, problem_id: Int32, student_id: Int32, content: String)
table(ProblemDetail, problem_id: Int32, ac: Int32, submit: Int32, wa: Int32, ce: Int32, me: Int32, te: Int32, re: Int32, pe: Int32, oe: Int32, last_person: String, ratio: Float32)
table(Status, username: String, problem_id: Int32, result: String, time_cost: Int32, space_cost: Int32, language: String, student_id: String, title: String, error: String)
table(User, student_id: String, username: String, classgrade: String, dormitory: String, phone: String, signature: String, avatar: String, qq: String, score: Int32, rank: Int32)
table(UserDetail, user_id: Int32, ac: Int32, submit: Int32, wa: Int32, pe: Int32, re: Int32, ce: Int32, te: Int32, me: Int32, oe: Int32, ac_records: String, contest_records: String)
table(UserLogin, user_id: Int32, student_id: String, password: String, auth_token: String)
table(UserProfile, user_id: Int32, theme: String, locale: String, mode: String, keymap: String, code_theme: String)
table(Manager, username: String, password: String, role: String, remark: String, token: String)
table(Contest, title: String, start_time: Time, end_time: Time, status: String, address: String, remark: String)
table(ContestProblem, contest_id: Int32, problem_id: String, title: String, time: Int32, space: Int32, ac: Int32, submit: Int32, description: Int32, testdata: Int32)
table(ContestStatus, contest_id: Int32, problem_id: String, student_id: String, result: String, time_cost: Int32, space_cost: Int32, language: String, username: String, title: String)
table(ContestRank, contest_id: Int32, ac: Int32, submit: Int32, details: String, student_id: String, username: String, penalty: Int32)
table(Rank, week_rank: Int32, username: String, student_id: String, week_score: Int32)

User.create
UserDetail.create
UserLogin.create
UserProfile.create

# 10.times do
#   Problem.rand_insert
# end

def generate_avatar(qq)
  store_dir = "/upload/user/avatar/#{qq}.jpg"
  system %(wget "http://q4.qlogo.cn/g?b=qq&nk=#{qq}&s=100" -O public/#{store_dir})
  store_dir
end

def generate_username(qq)
  username = `curl -s  http://r.pengyou.com/fcg-bin/cgi_get_portrait.fcg?uins=790174750 | iconv -f gbk -t utf8`[/\,"\w+"/]
end

require "secure_random"

# def generate_token : String
#   return SecureRandom.base64
# end

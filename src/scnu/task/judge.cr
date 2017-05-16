require "file_utils"
require "sidekiq"

class Judge
  include Sidekiq::Worker

  # 黑盒子
  # 输入： 代码， 时间限制，空间限制，题目测试数据，u_id, p_id
  # 输出： status，user, user_detail, problem, problem_detail
  def perform(code : String, lang : String, pid : Int32, uid : Int32)
    p = Problem.find(pid)[0]
    u = User.find(uid)[0]
    # 限定目录
    secure_id = mkdir_and_cd
    File.write(CODE_FILE[lang], code)
    error_info = ""
    if compile?
      result, time_cost, space_cost = run_many
    else
      result, time_cost, space_cost = CE, 0, 0
    end
    Status.insert(
      result: result,
      language: lang,
      problem_id: p.problem_id,
      title: p.title,
      time_cost: time_cost,
      space_cost: space_cost,
      username: u.username,
      student_id: u.student_id,
      error: error_info,
    )
    pd = ProblemDetail.last[0]
    ud = UserDetail.last[0]
    str = HASH[result]
    flag1 = (result == AC)
    flag2 = (flag1 && ud.ac_records.includes?(p.problem_id.to_s))
    Problem.update(p.id,
      submit: p.submit + 1,
      ac: flag1 ? p.ac + 1 : p.ac
    )
    User.update(u.id,
      score: u.score + 1,
    ) if flag2
    ProblemDetail.update(pd.id,
      submit: pd.submit + 1,
      ac: flag1 ? ud.ac + 1 : ud.ac,
      re: pd.re + str.bit(1),
      te: pd.te + str.bit(2),
      me: pd.me + str.bit(3),
      oe: pd.oe + str.bit(4),
      wa: pd.wa + str.bit(5),
      pe: pd.pe + str.bit(6),
      ratio: flag1 ? (pd.ac + 1).to_f / (pd.submit + 1) : pd.ac.to_f / (pd.submit + 1),
      last_person: flag1 ? u.username : pd.last_person
    )
    UserDetail.update(ud.id,
      submit: ud.submit + 1,
      ac: flag2 ? ud.ac + 1 : ud.ac,
      re: ud.re + str.bit(1),
      te: ud.te + str.bit(2),
      me: ud.me + str.bit(3),
      oe: ud.oe + str.bit(4),
      wa: ud.wa + str.bit(5),
      pe: ud.pe + str.bit(6),
      ac_records: flag2 ? ud.ac_records + "#{p.problem_id}#" : ud.ac_records
    )
    write_code if flag1
    rmdir(secure_id)
  end

  macro compile?
    build_cmd = BUILD_CMD[lang]
    process = Process.new(build_cmd, shell: true, input: true, output: true, error: nil)
    error = process.error.gets_to_end
    status = process.wait
    error_info = "#{u.student_id}_#{p.problem_id}_ce_#{rand(1000)}"
    File.write(error_path(error_info), error) if error != ""
    status.success?
  end

  macro run_many
    testdatas = Array(Array(String)).from_json File.read(testdata_path(p.problem_id))
    result = AC
    time_cost, space_cost = 0, 0
    testdatas.each do |testdata|
      stdin = testdata[0]
      user_out = ""
      exec_cmd = "timeout 1 #{EXE_CMD[lang]}"
      time_before_judge = Time.now.epoch_ms
      process = Process.new(exec_cmd, shell: true, input: nil, output: nil, error: nil)
      space_cost1 = (`cat /proc/#{process.pid}/status | grep VmHWM`)[/\d+/].to_i rescue 0
      process.input.puts stdin rescue nil
      user_out = process.output.gets_to_end
      error = process.error.gets_to_end
      status = process.wait
      time_cost = Time.now.epoch_ms - time_before_judge
      if status.exit_code == 124
        result = TE
      elsif status.exit_code != 0
        result = RE
        error_info = "#{u.student_id}_#{p.problem_id}_re_#{rand(1000)}"
        File.write(error_path(error_info), error)
      elsif user_out.size > 65535
        result = OE
      elsif user_out == testdata[1]
        result = AC
      elsif user_out.gsub(/\s+/, "") == testdata[1].gsub(/\s+/, "")
        result = PE
      else
        result = WA
      end
      break if result != AC
    end
    [result, time_cost, space_cost]
  end

  macro write_code
    code =<<-EOF
    > ** #{lang} ** #{Time.now.to_s("%Y-%m-%d %T")}
    ``` #{lang.downcase}
    #{code}
    ```
    EOF
    File.open(solution_path(u.student_id), "a+") { |f| f.puts(code)}
  end

  private def solution_path(student_id)
    "#{SOLUTION_PATH}/#{student_id}.md"
  end

  private def error_path(error_info)
    "#{ERROR_PATH}/#{error_info}.err"
  end

  private def testdata_path(problem_id)
    "#{TESTDATA_PATH}/#{problem_id}.json"
  end

  private def mkdir_and_cd : String
    secure_id = SecureRandom.hex
    FileUtils.mkdir("#{JUDGE_PATH}/#{secure_id}")
    FileUtils.cd("#{JUDGE_PATH}/#{secure_id}")
    secure_id
  end

  private def rmdir(secure_id)
    FileUtils.rm_rf("#{JUDGE_PATH}/#{secure_id}")
  end
end

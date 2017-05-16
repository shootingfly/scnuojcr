lib C
  # In C: double cos(double x)
  fun cos(value : Float64) : Float64
end

module S
  extend self

  def hello
    puts C.cos(1.5)
  end
end

lib C
  # In C: double cos(double x)
  fun cos(value : Float64) : Float64

  fun wait4(pid : Int32, status : Int32, option : Int32, usage : Rusage*) : Int32
  fun getrusage(who : Int32, usage : Rusage*) : Int32

  struct Timeval
    tv_sec : Int64
    tv_usec : Int64
  end

  struct Rusage
    ru_utime : Timeval
    ru_stime : Timeval
    ru_maxrss : Int64
    ru_ixrss : Int64
    ru_idrss : Int64
    ru_isrss : Int64
    ru_minflt : Int64
    ru_majflt : Int64
    ru_nswap : Int64
    ru_inblock : Int64
    ru_oublock : Int64
    ru_msgsnd : Int64
    ru_msgrcv : Int64
    ru_nsignals : Int64
    ru_nvcsw : Int64
    ru_nivcsw : Int64
  end
end

class LogMailer < ActionMailer::Base
  default from: "onrey_system_log@pinyue.com"

  def log_warning(email)
    @url = "http://baidu.com"

    mail(to:email, subject:'Nothing')
    puts "send mail"

  end
end

class Mails < ActionMailer::Base
  default :from => "from@example.com"
  
  
  def forgot_password(user)
    @user = user
    @url  = "http://example.com/login"
    mail(:to => 'deepak@idifysolutions.com', :subject => "hosting panel Password")
  end
end

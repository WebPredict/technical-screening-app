class ApplicationMailer < ActionMailer::Base
  default from: "admin@techscreen.herokuapp.com"
  layout 'mailer'
end

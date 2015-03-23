class CandidateMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def send_test(candidate, test)
    @candidate = candidate
    @test = test
    mail to: candidate.email, subject: "Test from TechScreen.net"
  end
  
end
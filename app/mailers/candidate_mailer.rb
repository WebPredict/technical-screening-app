class CandidateMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def send_test(candidate, test, sender_email)
    @candidate = candidate
    @test = test
    @sender_email = sender_email
    mail to: candidate.email, subject: @test.name + " Test from TechScreen.net"
  end
  
  def send_results(candidate, test_submission, destination)
    @candidate = candidate
    @test_submission = test_submission
    mail to: destination, subject: "Test Results From TechScreen.net for test " + @test_submission.test.name
  end
end

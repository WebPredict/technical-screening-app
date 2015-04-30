class Candidate < ActiveRecord::Base
  attr_accessor :test_token
  belongs_to :user

  has_and_belongs_to_many :jobs, :join_table => :jobs_candidates
  has_many :test_submissions, dependent: :destroy  
  validates :user_id, presence: true
  validates :name, presence: true
  validates :email, presence: true
  
  def Candidate.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def Candidate.new_token
    SecureRandom.urlsafe_base64
  end

  def valid_token?(token)
    return false if test_digest.nil?
    BCrypt::Password.new(test_digest).is_password?(token)
  end
  
  def has_digest?
    if test_digest != nil
      return true
    else
      return false
    end 
  end 
  
  def average_score
    @score = 0
    
    if test_submissions.any?
      @num_tests = test_submissions.size
      test_submissions.each do |submission|
        @score += submission.score
      end
      @score /= @num_tests
    end
    return @score
  end
  
  def send_test(test, sender_email)
    create_test_digest
    CandidateMailer.send_test(self, test, sender_email).deliver_now
  end
  
  def send_results(test_submission, destination)
    CandidateMailer.send_results(self, test_submission, destination).deliver_now
  end
  
  private
    def create_test_digest
      # probably fine for now to just create this once
      if self.test_token == nil
        self.test_token = Candidate.new_token
        update_attribute(:test_digest, Candidate.digest(self.test_token))
      end
    end
end

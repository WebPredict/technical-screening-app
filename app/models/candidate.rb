class Candidate < ActiveRecord::Base
  attr_accessor :test_token
  belongs_to :user
  default_scope -> { order(created_at: :desc) }

  has_and_belongs_to_many :jobs
  has_many :test_submissions  
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
  
  def send_test(test)
    create_test_digest
    CandidateMailer.send_test(self, test).deliver_now
  end
  
  def send_results(test_submission, destination)
    CandidateMailer.send_results(self, test_submission, destination).deliver_now
  end
  
  private
    def create_test_digest
      self.test_token = Candidate.new_token
      update_attribute(:test_digest, Candidate.digest(self.test_token))
    end
end

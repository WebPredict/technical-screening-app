class Candidate < ActiveRecord::Base
  attr_accessor :test_token
  belongs_to :user
  default_scope -> { order(created_at: :desc) }

  has_many :test_submissions  
  validates :user_id, presence: true
  
  def Candidate.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def Candidate.new_token
    SecureRandom.urlsafe_base64
  end
  
  def average_score
    @score = 0
    
    if test_submissions.any?
      @num_tests = test_submissions.size
      test_submissions.each do |submission|
        @score += test_submissions.score
      end
      @score /= @num_tests
    end
    return @score
  end
  
  def send_test(test)
    create_test_digest
    CandidateMailer.send_test(self, test).deliver_now
  end
  
  private
    def create_test_digest
      self.test_token = Candidate.new_token
      self.test_digest = Candidate.digest(test_token)
    end
end

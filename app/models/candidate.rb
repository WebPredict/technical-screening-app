class Candidate < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }

  has_many :test_submissions  
  validates :user_id, presence: true
  
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
end

class TestSubmission < ActiveRecord::Base
  belongs_to :user
  belongs_to :candidate
  belongs_to :test
  has_many :answered_questions
  accepts_nested_attributes_for :answered_questions
  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :candidate_id, presence: true
  validates :test_id, presence: true
  
  def formatted_score
    num_right = 0
    num_questions = 0
    
    if answered_questions.any?
      num_questions = answered_questions.size
      answered_questions.each do |aq|
        if aq.correct?
          num_right += 1
        end
      end
    end
    @score = num_right.to_f / num_questions.to_f
    return (@score * 100.0).to_s + "% (" + num_right.to_s + " out of " + num_questions.to_s + ")"
  end
  
end

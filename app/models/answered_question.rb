class AnsweredQuestion < ActiveRecord::Base
  belongs_to :question
  belongs_to :test_submission
  validates :question_id, presence: true
  validates :test_submission_id, presence: true
end

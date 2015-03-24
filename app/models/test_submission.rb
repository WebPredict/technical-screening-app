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
end

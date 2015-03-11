class Candidate < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }

  has_many :test_submissions  
  validates :user_id, presence: true
end

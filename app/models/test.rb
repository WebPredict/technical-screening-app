class Test < ActiveRecord::Base
  belongs_to :user
  has_many :questions
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
end

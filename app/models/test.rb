class Test < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :questions
  has_many :test_submissions
  validates :user_id, presence: true
  validates :name, presence: true
end

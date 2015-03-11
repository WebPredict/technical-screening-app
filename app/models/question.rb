class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :test
  validates :user_id, presence: true
  validates :difficulty_id, presence: true
  validates :category_id, presence: true
end

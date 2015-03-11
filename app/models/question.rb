class Question < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :tests
  validates :user_id, presence: true
  validates :difficulty_id, presence: true
  validates :category_id, presence: true
end

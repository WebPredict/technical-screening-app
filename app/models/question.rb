class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :difficulty
  belongs_to :category 
  has_and_belongs_to_many :tests
  validates :user_id, presence: true
  validates :difficulty_id, presence: true
  validates :category_id, presence: true
  validates :content, presence: true
end

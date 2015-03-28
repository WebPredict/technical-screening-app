class Question < ActiveRecord::Base
  attr_accessor :answer2, :answer3, :answer4, :answer5
  belongs_to :user
  belongs_to :difficulty
  belongs_to :category 
  belongs_to :question_type
  has_many :answered_questions
  has_and_belongs_to_many :tests
  validates :user_id, presence: true
  validates :difficulty_id, presence: true
  validates :category_id, presence: true
  validates :question_type_id, presence: true
  validates :content, presence: true
end

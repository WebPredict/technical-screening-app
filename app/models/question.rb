class Question < ActiveRecord::Base
  attr_accessor :answer2, :answer3, :answer4, :answer5, :multiple_choice_answer, :short_answer
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
  
  def formatted_content
    answers = content.split("||")
    
    formatted = answers [0]
    if answers.size > 1
      formatted += " A) " + answers [1]
    end 
    if answers.size > 2
      formatted += " B) " + answers [2]
    end 
    if answers.size > 3
      formatted += " C) " + answers [3]
    end 
    if answers.size > 4
      formatted += " D) " + answers [4]
    end 
    return formatted 
  end 
  
end

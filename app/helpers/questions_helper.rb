module QuestionsHelper
  
  def setup_question(question)
    split_answers = question.content.split("||")
    question.content = split_answers [0]
    if split_answers.size > 1
      question.answer2 = split_answers [1]
    end 
    if split_answers.size > 2
      question.answer3 = split_answers [2]
    end 
    if split_answers.size > 3
      question.answer4 = split_answers [3]
    end 
    if split_answers.size > 4
      question.answer5 = split_answers [4]
    end 
    
    if question.question_type_id == 3
      question.short_answer = question.answer
    end
  end
end

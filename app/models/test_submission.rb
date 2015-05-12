class TestSubmission < ActiveRecord::Base
  belongs_to :user
  belongs_to :candidate
  belongs_to :test
  has_many :answered_questions
  accepts_nested_attributes_for :answered_questions

  validates :user_id, presence: true
  validates :candidate_id, presence: true
  validates :test_id, presence: true
  
  def formatted_time
    if start_time != nil && end_time != nil
      @time = (end_time - start_time).to_i
      return "#{@time} sec"
    else
      return "N/A"
    end
  end 

  def set_times(start_t, end_t)
    update_attributes(:start_time => start_t, :end_time => end_t)
    if end_time != nil && start_time != nil 
      update_attribute(:duration, (end_time - start_time).to_i)
    end 
  end 
  
  def formatted_score
    if !is_scored
      return "Not scored yet"
    else
      num_right = 0
      num_questions = 0
      
      if answered_questions.any?
        num_questions = answered_questions.size
        answered_questions.each do |aq|
          if aq.correct?
            num_right += 1
          end
        end
      end
      
      if num_questions != 0
        @score = num_right.to_f / num_questions.to_f
      else
        @score = 0
      end
      @score *= 100.0
      return "#{@score.round(1)} % (" + num_right.to_s + " out of " + num_questions.to_s + ")"
    end
  end
  
  def update_avg_scores 
    if is_scored
      num_right = 0
      num_questions = 0
      
      if answered_questions.any?
        num_questions = answered_questions.size
        answered_questions.each do |aq|
          if aq.correct?
            num_right += 1
          end
        end
      end
      
      if num_questions != 0
        @score = num_right.to_f / num_questions.to_f
      else
        @score = 0
      end
      @score *= 100.0
      
      update_attribute(:score, @score)
      candidate.avg_score = @score
      candidate.save
    end
  end
  
end

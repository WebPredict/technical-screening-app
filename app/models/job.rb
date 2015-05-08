class Job < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  has_and_belongs_to_many :candidates, :join_table => :jobs_candidates
  
  validates :name, presence: true, length: { maximum: 255 }
  validates :user_id, presence: true

  def open?
    return closed_date == nil
  end 

end
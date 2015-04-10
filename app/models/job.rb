class Job < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  has_and_belongs_to_many :candidates
  
  default_scope -> { order(created_at: :desc) }

  validates :name, presence: true, length: { maximum: 255 }

  validates :user_id, presence: true
  validates :company_id, presence: true

end
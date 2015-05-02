class Note < ActiveRecord::Base

  validates :content, presence: true, length: { maximum: 4000 }
  validates :candidate_id, presence: true

end
class Company < ActiveRecord::Base
  has_and_belongs_to_many :users
  #mount_uploader :picture, PictureUploader
  #validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 255 }
  #validate  :picture_size
  has_many :jobs
  
  private
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
    
end

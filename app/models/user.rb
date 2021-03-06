class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  
  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, allow_blank: true
  
  has_many :questions
  has_many :jobs
  has_many :candidates, dependent: :destroy
  has_many :tests, dependent: :destroy
  has_and_belongs_to_many :companies
  belongs_to :membership_level
  
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  def premium?
    return membership_level != nil && membership_level.id != 1
  end
  
  def feed
    #following_ids = "SELECT followed_id FROM relationships
                     #WHERE  follower_id = :user_id"
    #Micropost.where("user_id IN (#{following_ids})
                     #OR user_id = :user_id", user_id: id)
  end
  
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  def company_list
    list = ''
    if companies.any?
      companies.each do |c|
        if list == ''
          list = c.name
        else
          list = list + ", " + c.name
        end 
      end
    end
    return list
  end 

  def trial_expired?
    if membership_level_id == 1 && created_at < 14.days.ago
      true
    else
      false
    end
  end
  
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
    UserMailer.notify_of_new_user(self).deliver_now
  end
  
  private
    def downcase_email
      self.email = email.downcase
    end
    
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
    
end

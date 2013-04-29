require 'securerandom'

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation

  before_validation :generate_long_id, :generate_trial_expire

  has_secure_password

  # Associations
  has_many :clients, dependent: :destroy
  has_many :projects, through: :clients

  has_many :events, dependent: :destroy

  has_many :enquiries, dependent: :destroy

  # Validations
  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  validates :long_id, presence: true, uniqueness: true


  # Methods
  def client_limit
    if self.account_type == "lite" ||
       self.account_type == "trial"
      return 24
    elsif self.account_type == "standard" || 
          self.account_type == "tester"   ||
          self.account_type == "admin"
      return 256
    end
  end

  def project_limit
    if self.account_type == "lite" ||
       self.account_type == "trial"
      return 4
    elsif self.account_type == "standard" || 
          self.account_type == "tester"   ||
          self.account_type == "admin"
      return 24
    end
  end

  private

    # Before Filters
    def generate_long_id
      if self.long_id.nil?
        self.long_id = SecureRandom.hex(16)
      end
    end

    def generate_trial_expire
      if self.trial_expire.nil?
        self.trial_expire = 14.days.from_now
      end
    end

end

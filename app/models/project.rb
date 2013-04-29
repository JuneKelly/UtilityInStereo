require 'securerandom'

class Project < ActiveRecord::Base
  attr_accessible :deadline, :deposit, :deposit_paid, 
                  :details, :hourly_rate, :is_done, 
                  :is_paid_in_full, :quotation, :title,
                  :has_client_view, :client_view_message

  before_validation :generate_long_id

  # Relations
  belongs_to :client
  has_one :user, through: :client
  has_many :phases, dependent: :destroy
  has_many :tasks, through: :phases

  validates_presence_of :title
  validates :client_id, presence: true

  validates :long_id, presence: true, uniqueness: true

  # Scopes

  def mark_as_done
    self.is_done = true
    self.save
  end

private
  # Before Filters
  def generate_long_id
    if self.long_id.nil?
      self.long_id = SecureRandom.hex(16)
    end
  end

end

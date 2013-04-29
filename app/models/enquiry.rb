class Enquiry < ActiveRecord::Base
  attr_accessible :name, :email, :message, :viewed

  validates_presence_of :name, :email
  validates :user_id, presence: true

  # Relations
  belongs_to :user
end

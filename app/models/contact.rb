class Contact < ActiveRecord::Base
  attr_accessible :email, :name, :phone, :role

  belongs_to :client
  has_one :user, through: :client

  validates_presence_of :name
  validates :client_id, presence: true
end

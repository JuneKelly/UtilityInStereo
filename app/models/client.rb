class Client < ActiveRecord::Base
  attr_accessible :name, :description, :website

  belongs_to :user
  has_many :contacts, dependent: :destroy
  has_many :projects, dependent: :destroy

  validates_presence_of :name
  validates :user_id, presence: true

end

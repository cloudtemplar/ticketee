class Ticket < ApplicationRecord
  belongs_to :project
  belongs_to :author, class_name: 'User'
  belongs_to :state, optional: true
  has_many :attachments, dependent: :destroy, inverse_of: :ticket
  has_many :comments, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank
  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 10 }
end

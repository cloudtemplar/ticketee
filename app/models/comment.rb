class Comment < ApplicationRecord
  belongs_to :ticket
  belongs_to :author, class_name: 'User'
  validates :text, presence: true
  delegate :project, to: :ticket
  scope :persisted, -> { where.not(id: nil) }
end

class Project < ApplicationRecord
  has_many :tickets, dependent: :delete_all
  validates :name, presence: true, length: { minimum: 3 }
end

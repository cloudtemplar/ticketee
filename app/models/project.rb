class Project < ApplicationRecord
  has_many :tickets
  validates :name, presence: true, length: { minimum: 3 }
end

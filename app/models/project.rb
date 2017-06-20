class Project < ApplicationRecord
  has_many :tickets, dependent: :delete_all
  has_many :roles, dependent: :delete_all
  validates :name, presence: true, length: { minimum: 3 }

  # Some helper methods for Pundit policies.
  def has_member?(user)
    roles.exists?(user_id: user)
  end

  [:manager, :editor, :viewer].each do |role|
    define_method "has_#{role}?" do |user|
      roles.exists?(user_id: user, role: role)
    end
  end
end

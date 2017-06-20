class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def to_s
    "#{email} (#{admin? ? 'Admin' : 'User'})"
  end
end

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :not_archived, -> { where(archived_at: nil) }

  def to_s
    "#{email} (#{admin? ? 'Admin' : 'User'})"
  end

  def archive
    self.update(archived_at: Time.now)
  end
end

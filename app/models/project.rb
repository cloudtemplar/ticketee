class Project < ApplicationRecord
  has_many :tickets, dependent: :destroy do
    def search(params)
      # If search query match pattern of e.g. 'tag:new'.
      if params =~ /\A\w+:\w+\z/
        attribute = params.match(/\A(\w+):/)[1].pluralize.to_sym
        value = params.match(/:(\w+)\z/)[1]
        joins(attribute).where("#{attribute}.name = '#{value}'")
      else
        # Return the whole collection otherwise.
        return self
      end
    end
  end
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

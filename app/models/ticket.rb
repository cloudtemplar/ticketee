class Ticket < ApplicationRecord
  belongs_to :project
  belongs_to :author, class_name: 'User', optional: true
  belongs_to :state, optional: true
  has_many :attachments, dependent: :destroy, inverse_of: :ticket
  has_many :comments, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :ticket_watchings, dependent: :destroy
  has_many :watchers, through: :ticket_watchings, source: :user
  attr_accessor :tag_names
  accepts_nested_attributes_for :attachments, reject_if: :all_blank
  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 10 }
  before_create :assign_default_state
  after_create :author_watches_me

  def tag_names=(names)
    @tag_names = names
    names.split.each do |name|
      self.tags << Tag.find_or_initialize_by(name: name)
    end
  end

  private

    def assign_default_state
      self.state ||= State.default
    end

    def author_watches_me
      if author.present? && !self.watchers.include?(author)
        self.watchers << author
      end
    end
end

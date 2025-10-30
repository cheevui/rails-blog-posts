class BlogPost < ApplicationRecord
    has_rich_text :content
    has_one_attached :featured_image
    attr_accessor :remove_featured_image

    validates :title, presence: true
    validates :content, presence: true

    belongs_to :user
    has_many :comments, dependent: :destroy

    include PgSearch::Model
    pg_search_scope :search_by_title,
    against: :title,
    using: {
      tsearch: { prefix: true } # allows partial matches, e.g. "dev" matches "development"
    }
end

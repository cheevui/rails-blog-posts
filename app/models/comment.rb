class Comment < ApplicationRecord
  has_rich_text :content
  belongs_to :user
  belongs_to :blog_post

  validates :content, presence: true
end

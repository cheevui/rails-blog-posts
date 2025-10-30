class AddUserToBlogPosts < ActiveRecord::Migration[8.1]
  def change
    add_reference :blog_posts, :user, null: false, foreign_key: true
  end
end

class SeedPosts < ActiveRecord::Migration[5.0]
  def change
    Post.create([
      {title: "First post", body: "This post was created by db/seeds.rb"},
      {title: "Second post", body: "This post was also created by db/seeds.rb"},
    ])
  end
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Post.create([
  {title: "First post", body: "This post was created by db/seeds.rb"},
  {title: "Second post", body: "This post was also created by db/seeds.rb"},
])

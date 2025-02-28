# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

[
  { name: "Alice", password: "password", password_confirmation: "password" },
  { name: "Bob", password: "password", password_confirmation: "password" },
  { name: "Charlie", password: "password", password_confirmation: "password" },
  { name: "David", password: "password", password_confirmation: "password" },
  { name: "Eve", password: "password", password_confirmation: "password" },
].each do |user|
  User.find_or_create_by!(name: user[:name]) do |u|
      u.password = user[:password]
      u.password_confirmation = user[:password_confirmation]
  end
end

puts "Seeded users finished"

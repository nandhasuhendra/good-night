if ["DUMMY_DATA"] == 'true'
  [
    { name: "Alice", password: "password", password_confirmation: "password" },
    { name: "Bob", password: "password", password_confirmation: "password" },
    { name: "Charlie", password: "password", password_confirmation: "password" },
    { name: "David", password: "password", password_confirmation: "password" },
    { name: "Eve", password: "password", password_confirmation: "password" }
  ].each do |user|
      User.find_or_create_by!(name: user[:name]) do |u|
        u.password = user[:password]
        u.password_confirmation = user[:password_confirmation]
      end
    end

  [
    { followed_id: 1, following_id: 2 },
    { followed_id: 1, following_id: 3 },
    { followed_id: 1, following_id: 4 },
    { followed_id: 1, following_id: 5 },
    { followed_id: 2, following_id: 1 },
    { followed_id: 2, following_id: 3 },
    { followed_id: 2, following_id: 4 },
    { followed_id: 2, following_id: 5 },
    { followed_id: 3, following_id: 1 },
    { followed_id: 3, following_id: 2 },
    { followed_id: 3, following_id: 4 },
    { followed_id: 3, following_id: 5 },
    { followed_id: 4, following_id: 1 },
    { followed_id: 4, following_id: 2 },
    { followed_id: 4, following_id: 3 },
    { followed_id: 4, following_id: 5 },
    { followed_id: 5, following_id: 1 },
    { followed_id: 5, following_id: 2 },
    { followed_id: 5, following_id: 3 },
    { followed_id: 5, following_id: 4 }
  ].each do |follow|
      Follow.find_or_create_by!(followed_id: follow[:followed_id], following_id: follow[:following_id])
    end

  %w[Alice Bob Charlie David Eve].each do |name|
    puts "Seeding sleep records for #{name}"
    1_000.times do |i|
      SleepRecord.create!(user_id: User.find_by(name: name).id, clock_in: Time.now - i.day, clock_out: Time.now - i.day + rand(1..8).hours)
    end
    puts "Seeding sleep records for #{name} finished"
  end
end

if ENV["PERFORMANCE_TEST_PURPOSES"] == 'true'
  1_000.times do |i|
    User.create!(name: "User#{i}", password: "password", password_confirmation: "password")
    puts "Seeded #{i} users" if i % 100 == 0
  end
end

puts "Seeded users finished"

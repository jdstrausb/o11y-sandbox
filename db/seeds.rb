# puts "Cleaning database..."
# Author.destroy_all

# puts "Creating data..."
# 50.times do |i|
#   author = Author.create!(name: "Author #{i}")
  
#   5.times do |j|
#     Book.create!(title: "Book #{j} by #{author.name}", author: author)
#   end
# end

# puts "Done! Created #{Author.count} authors and #{Book.count} books."

puts "Cleaning old data..."
User.delete_all

puts "Generating 1 Million Users (this might take 10-20 seconds)..."

# We will insert in batches of 10,000 to keep SQLite happy
batch_size = 10_000
total_records = 1_000_000

(total_records / batch_size).times do |i|
  users_data = []
  
  batch_size.times do |j|
    users_data << {
      email: "user_#{i}_#{j}@example.com",
      api_token: SecureRandom.hex(10),
      last_seen_at: Time.now,
      created_at: Time.now,
      updated_at: Time.now
    }
  end
  
  # Bulk insert bypasses ActiveRecord instantiations for speed
  User.insert_all(users_data)
  print "."
end

puts "\nDone! DB now has #{User.count} users."

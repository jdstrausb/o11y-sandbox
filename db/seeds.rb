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
# ---

# puts "Cleaning old data..."
# User.delete_all

# puts "Generating 1 Million Users (this might take 10-20 seconds)..."

# # We will insert in batches of 10,000 to keep SQLite happy
# batch_size = 10_000
# total_records = 1_000_000

# (total_records / batch_size).times do |i|
#   users_data = []
  
#   batch_size.times do |j|
#     users_data << {
#       email: "user_#{i}_#{j}@example.com",
#       api_token: SecureRandom.hex(10),
#       last_seen_at: Time.now,
#       created_at: Time.now,
#       updated_at: Time.now
#     }
#   end
  
#   # Bulk insert bypasses ActiveRecord instantiations for speed
#   User.insert_all(users_data)
#   print "."
# end

# puts "\nDone! DB now has #{User.count} users."
# ---

puts "Cleaning old log entries..."
LogEntry.delete_all

puts "Generating 10,000 LogEntry records..."

# Standard log severity levels
severities = %w[DEBUG INFO WARN ERROR FATAL]

# Sample message templates for variety
message_templates = [
  "User login successful",
  "Database query executed",
  "Cache miss detected",
  "API request received",
  "Background job started",
  "Payment processed",
  "Email sent successfully",
  "File uploaded",
  "Authentication failed",
  "Rate limit exceeded",
  "Memory usage high",
  "Connection timeout",
  "Invalid request format",
  "Session expired",
  "Data validation error",
  "External service unavailable",
  "Configuration updated",
  "Health check passed",
  "Backup completed",
  "Index rebuild started"
]

# Generate timestamps distributed over the last 24 hours
now = Time.now
twenty_four_hours_ago = now - 24.hours

# Use insert_all in batches for performance
batch_size = 1_000
total_records = 10_000

(total_records / batch_size).times do |i|
  log_entries_data = []
  
  batch_size.times do |j|
    # Distribute timestamps evenly over 24 hours
    # Each record gets a timestamp that's (record_number / total_records) * 24 hours from the start
    record_number = (i * batch_size) + j
    hours_offset = (record_number.to_f / total_records) * 24
    timestamp = twenty_four_hours_ago + hours_offset.hours
    
    # Add some randomness to the timestamp (±5 minutes) for more realistic distribution
    timestamp += rand(-300..300).seconds
    
    # Randomize severity and message
    severity = severities.sample
    base_message = message_templates.sample
    message = "#{base_message} - Request ID: #{SecureRandom.hex(8)}"
    
    # Add some variation to messages
    if rand < 0.3
      message += " | Duration: #{rand(10..5000)}ms"
    end
    if rand < 0.2
      message += " | User ID: #{rand(1..10000)}"
    end
    
    log_entries_data << {
      timestamp: timestamp,
      severity: severity,
      message: message,
      created_at: Time.now,
      updated_at: Time.now
    }
  end
  
  # Bulk insert bypasses ActiveRecord instantiations for speed
  LogEntry.insert_all(log_entries_data)
  print "."
end

puts "\nDone! Created #{LogEntry.count} log entries."

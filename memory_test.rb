# memory_test.rb
# Script to compare memory usage between User.all.each and User.find_each

require_relative 'config/environment'

# Helper method to print current process memory usage in MB
def print_mem(label)
  rss_kb = `ps -o rss= -p #{Process.pid}`.strip.to_i
  rss_mb = (rss_kb / 1024.0).round(2)
  puts "#{label}: #{rss_mb} MB"
end

puts "\n" + "="*60
puts "MEMORY USAGE COMPARISON: User.all.each vs User.find_each"
puts "="*60 + "\n"

# ============================================================
# SCENARIO A: User.all.each (loads all records into memory)
# ============================================================
puts "\n" + "-"*60
puts "SCENARIO A: User.all.each"
puts "-"*60 + "\n"

print_mem("Before Scenario A")

# Force Rails to instantiate all objects by calling .load
# This executes the query and loads all records into memory
puts "\nLoading all users into memory (this may take a moment)..."
all_users = User.all.load
print_mem("After loading all users")

count = 0
print_mem("Before iteration")
all_users.each do |user|
  # Trivial operation
  user.email
  
  count += 1
  if count % 10_000 == 0
    print_mem("  During iteration (processed #{count} records)")
  end
  
  # Break after 100,000 records to prevent freezing
  break if count >= 100_000
end

print_mem("After Scenario A (processed #{count} records)")

# Clear the reference to help with garbage collection
all_users = nil
GC.start

puts "\nWaiting a moment for garbage collection..."
sleep(2)
print_mem("After GC")

# ============================================================
# SCENARIO B: User.find_each (batched loading)
# ============================================================
puts "\n" + "-"*60
puts "SCENARIO B: User.find_each"
puts "-"*60 + "\n"

print_mem("Before Scenario B")

count = 0
print_mem("Before iteration")
User.find_each do |user|
  # Trivial operation
  user.email
  
  count += 1
  if count % 10_000 == 0
    print_mem("  During iteration (processed #{count} records)")
  end
  
  # Break after 100,000 records for fair comparison
  break if count >= 100_000
end

print_mem("After Scenario B (processed #{count} records)")

puts "\n" + "="*60
puts "COMPARISON COMPLETE"
puts "="*60
puts "\nNote: Scenario A loads all records into memory at once,"
puts "while Scenario B loads records in batches (default 1000)."
puts "This difference should be visible in the memory usage above."
puts "="*60 + "\n"


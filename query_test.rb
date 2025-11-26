# query_test.rb

# 1. Setup Logging to STDOUT so we can see the queries
ActiveRecord::Base.logger = Logger.new(STDOUT)

puts "\n" + "="*50
puts "SCENARIO 1: The N+1 Query (The 'Bad' Way)"
puts "="*50 + "\n"

# We wrap this in a block to measure time purely for the operation
start_time = Time.now

# --- THE BAD CODE ---
# We fetch all authors (1 Query)
authors = Author.all

authors.each do |author|
  # For EACH author, we access .books
  # This triggers a new SQL query for every single loop iteration.
  # If there are 50 authors, this runs 50 extra queries.
  print "Author: #{author.name} wrote #{author.books.count} books | "
end
# --------------------

end_time = Time.now
duration_n1 = end_time - start_time

puts "\n\n" + "="*50
puts "SCENARIO 2: Eager Loading (The 'Fixed' Way)"
puts "="*50 + "\n"

start_time = Time.now

# --- THE GOOD CODE ---
# We fetch all authors AND tell ActiveRecord to fetch associated books immediately
# using .includes(:books)
authors = Author.includes(:books).all

authors.each do |author|
  # Rails has already loaded the books into memory. 
  # Accessing .books here does NOT trigger a database query.
  print "Author: #{author.name} wrote #{author.books.count} books | "
end
# ---------------------

end_time = Time.now
duration_includes = end_time - start_time

# Results Summary
puts "\n\n" + "="*50
puts "RESULTS SUMMARY"
puts "="*50
puts "N+1 Scenario Time:   #{duration_n1.round(4)} seconds"
puts "Includes Fix Time:   #{duration_includes.round(4)} seconds"
puts "Improvement:         #{((duration_n1 / duration_includes) * 100).round(2)}% faster"
puts "="*50

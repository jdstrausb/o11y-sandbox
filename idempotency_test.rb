# idempotency_test.rb
user = User.first
# Reset state
user.update!(credits: 0, bonus_awarded: false)

puts "\n--- TESTING DANGEROUS JOB (Double Fire) ---"
# Simulate job running twice due to network retry
AwardBonusJob.new.perform_dangerous(user.id)
AwardBonusJob.new.perform_dangerous(user.id)

puts "Result: User has #{user.reload.credits} credits (Should be 10)"

puts "\n--- TESTING IDEMPOTENT JOB (Double Fire) ---"
# Reset
user.update!(credits: 0, bonus_awarded: false)

AwardBonusJob.new.perform_idempotent(user.id)
AwardBonusJob.new.perform_idempotent(user.id)

puts "Result: User has #{user.reload.credits} credits (Should be 10)"

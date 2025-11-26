class AwardBonusJob < ApplicationJob
  queue_as :default

  # SCENARIO 1: The Non-Idempotent Way (Dangerous)
  # If this job retries (e.g. Redis crashes after update but before success),
  # the user gets paid twice.
  def perform_dangerous(user_id)
    user = User.find(user_id)
    
    # Simple increment
    # If run twice, user gets +20 instead of +10
    user.update!(credits: (user.credits || 0) + 10)
    
    puts "Dangerous: User #{user.id} credits are now #{user.credits}"
  end

  # SCENARIO 2: The Idempotent Way (Safe)
  # We check the state BEFORE acting.
  def perform_idempotent(user_id)
    user = User.find(user_id)

    if user.bonus_awarded?
      puts "Idempotent: User #{user.id} already has the bonus. Skipping."
      return
    end

    # Use a Transaction to ensure atomic updates
    User.transaction do
      # Re-fetch lock to prevent race conditions (advanced safety)
      user.lock! 
      
      unless user.bonus_awarded?
        user.update!(
          credits: (user.credits || 0) + 10, 
          bonus_awarded: true
        )
        puts "Idempotent: User #{user.id} awarded bonus! Credits: #{user.credits}"
      end
    end
  end
end

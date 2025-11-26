class User < ApplicationRecord

  # Constants for readable configuration
  INACTIVE_THRESHOLD = 30.days
  VIP_CREDIT_THRESHOLD = 100
  ACTIVE_THRESHOLD = 1.day
  BONUS_BOOKS_THRESHOLD = 10
  BONUS_CREDITS = 5

  # Refactored method following Rails Doctrine:
  # - Extracted magic numbers to constants
  # - Used guard clauses to reduce nesting
  # - Optimized queries (use .size instead of .count)
  # - Fixed race condition with increment!
  def process_status_update
    handle_inactive_user if inactive?
    handle_active_user if active_recently?
    award_bonus_credits if eligible_for_bonus?
  end

  private

  def inactive?
    last_seen_at < INACTIVE_THRESHOLD.ago
  end

  def active_recently?
    last_seen_at > ACTIVE_THRESHOLD.ago
  end

  def eligible_for_bonus?
    # Use .size instead of .count to leverage counter_cache if available
    # or use the already-loaded association
    books.size > BONUS_BOOKS_THRESHOLD
  end

  def handle_inactive_user
    if credits > VIP_CREDIT_THRESHOLD
      puts "Sending VIP comeback email"
      # Imagine complex mailing logic here
    else
      puts "Sending standard comeback email"
    end
    update(active: false)
  end

  def handle_active_user
    if email.include?("@admin.com")
      puts "Admin user active"
    else
      puts "Regular user active"
    end
    update(active: true)
  end

  def award_bonus_credits
    # Use increment! to avoid race conditions - it's atomic at the DB level
    increment!(:credits, BONUS_CREDITS)
  end
  
end

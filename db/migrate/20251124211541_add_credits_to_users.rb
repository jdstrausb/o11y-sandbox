class AddCreditsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :credits, :integer
    add_column :users, :bonus_awarded, :boolean
  end
end

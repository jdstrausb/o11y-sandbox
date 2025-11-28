class AddIndicesToLogEntries < ActiveRecord::Migration[8.0]
  def change
    add_index :log_entries, :timestamp
    add_index :log_entries, :severity
  end
end

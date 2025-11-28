class CreateLogEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :log_entries do |t|
      t.datetime :timestamp
      t.string :severity
      t.text :message

      t.timestamps
    end
  end
end

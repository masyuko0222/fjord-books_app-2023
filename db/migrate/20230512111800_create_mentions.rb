class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.integer :mention_from_id
      t.integer :mention_to_id

      t.timestamps
    end
  add_index :mentions, :mention_from_id
  add_index :mentions, :mention_to_id
  add_index :mentions, [:mention_from_id, :mention_to_id], unique: true
  end
end

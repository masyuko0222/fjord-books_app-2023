class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.belongs_to :mention_from, foreign_key: { to_table: :reports }
      t.belongs_to :mention_to, foreign_key: { to_table: :reports }

      t.timestamps
    end
    add_index :mentions, [:mention_from_id, :mention_to_id], unique: true
  end
end

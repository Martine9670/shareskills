class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.text :body
      t.boolean :read, default: false, null: false
      t.string :subject
      t.datetime :proposed_at
      t.index [:sender_id]
      t.index [:receiver_id]

      t.timestamps
    end
  end
end

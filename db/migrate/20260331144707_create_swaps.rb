class CreateSwaps < ActiveRecord::Migration[8.1]
  def change
    create_table :swaps do |t|
      t.references :proposer, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.references :skill, null: false, foreign_key: true
      t.integer :duration
      t.text :message
      t.string :status, default: "pending"

      t.timestamps
    end
  end
end

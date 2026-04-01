class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :location
      t.text :bio
      t.integer :credits_minutes, default: 120
      t.boolean :is_admin,        default: false
      t.float   :rating,          default: 0.0
      t.integer :swaps_count,     default: 0

      t.timestamps
    end
  end
end

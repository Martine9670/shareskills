class CreateUserSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :user_skills do |t|
      t.references :user, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
      t.string :level
      t.string :skill_type

      t.timestamps
    end
  end
end

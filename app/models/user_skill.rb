class UserSkill < ApplicationRecord
  belongs_to :user
  belongs_to :skill

  validates :level,      inclusion: { in: %w[beginner intermediate expert] }
  validates :skill_type, inclusion: { in: %w[teach learn] }
  validates :skill_id,   uniqueness: { scope: [:user_id, :skill_type],
                                       message: "déjà ajoutée" }
end

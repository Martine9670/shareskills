class Skill < ApplicationRecord
  has_many :user_skills, dependent: :destroy
  has_many :users, through: :user_skills
  has_many :swaps, dependent: :destroy

  validates :name,     presence: true, uniqueness: { case_sensitive: false }
  validates :category, presence: true,
                       inclusion: { in: %w[tech music cooking design language other] }

  CATEGORIES = {
    "tech"     => "💻 Tech",
    "music"    => "🎵 Musique",
    "cooking"  => "🍳 Cuisine",
    "design"   => "🎨 Design",
    "language" => "🗣 Langue",
    "other"    => "✨ Autre"
  }.freeze
end

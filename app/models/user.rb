class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar_image

  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills
  has_many :proposed_swaps,  class_name: "Swap",    foreign_key: :proposer_id,  dependent: :destroy
  has_many :received_swaps,  class_name: "Swap",    foreign_key: :receiver_id,  dependent: :destroy
  has_many :sent_messages,   class_name: "Message", foreign_key: :sender_id,    dependent: :destroy
  has_many :received_messages, class_name: "Message", foreign_key: :receiver_id, dependent: :destroy

  validates :name,     presence: true
  validates :email,    presence: true, uniqueness: { case_sensitive: false },
                       format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :location, presence: true

  before_save { self.email = email.downcase }

  def teach_skills
    user_skills.includes(:skill).where(skill_type: "teach")
  end

  def learn_skills
    user_skills.includes(:skill).where(skill_type: "learn")
  end

  def all_swaps
    Swap.where("proposer_id = ? OR receiver_id = ?", id, id).order(created_at: :desc)
  end

  def avatar_url
    return Rails.application.routes.url_helpers.rails_blob_path(avatar_image, only_path: true) if avatar_image.attached?

    "https://i.pravatar.cc/150?u=#{email}"
  end
end

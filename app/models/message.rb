class Message < ApplicationRecord
  belongs_to :sender,   class_name: "User", foreign_key: :sender_id
  belongs_to :receiver, class_name: "User", foreign_key: :receiver_id

  validates :body,    presence: true
  validates :subject, presence: true

  scope :unread_for, ->(user) { where(receiver: user, read: false) }
  scope :conversation_between, ->(u1, u2) {
    where(sender_id: [u1.id, u2.id], receiver_id: [u1.id, u2.id]).order(:created_at)
  }
end

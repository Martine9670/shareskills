class Swap < ApplicationRecord
  belongs_to :proposer, class_name: "User"
  belongs_to :receiver, class_name: "User"
  belongs_to :skill

  validates :duration, presence: true, inclusion: { in: [30, 60, 90, 120] }
  validates :status,   inclusion: { in: %w[pending accepted rejected] }

  scope :pending,  -> { where(status: "pending") }
  scope :accepted, -> { where(status: "accepted") }

  def accept!
    transaction do
      update!(status: "accepted")
      receiver.decrement!(:credits_minutes, duration)
      proposer.increment!(:credits_minutes, duration)
      proposer.increment!(:swaps_count)
      receiver.increment!(:swaps_count)
    end
  end

  def reject!
    update!(status: "rejected")
  end
end

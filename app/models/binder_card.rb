class BinderCard < ApplicationRecord
  belongs_to :binder
  belongs_to :card

  validates :binder_id, presence: true
  validates :card_id, presence: true
end

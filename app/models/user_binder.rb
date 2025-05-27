class UserBinder < ApplicationRecord
  belongs_to :user
  belongs_to :binder

  validates :user_id, presence: true
  validates :binder_id, presence: true
end

class UserBinder < ApplicationRecord
  belongs_to :user
  belongs_to :binder

  validates :user_id, presence: true
  validates :binder_id, presence: true

  it { should belong_to(:user) }
  it { should belong_to(:binder) }
end

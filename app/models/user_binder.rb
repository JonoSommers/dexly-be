class UserBinder < ApplicationRecord
  belongs_to :user
  belongs_to :binder
end

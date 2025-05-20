class User < ApplicationRecord
    has_secure_password
    has_many :user_binders, dependent: :destroy
    has_many :binders, through: :user_binders
end

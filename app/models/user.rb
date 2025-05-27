class User < ApplicationRecord
    has_secure_password
    has_many :user_binders, dependent: :destroy
    has_many :binders, through: :user_binders

    validates :username, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 10 }
end

class User < ApplicationRecord
    has_secure_password
    VALID_PASSWORD_REGEX = /\A(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*]).{8,}\z/
    has_many :user_binders, dependent: :destroy
    has_many :binders, through: :user_binders

    validates :username, presence: true, uniqueness: true
    validates :password, 
        presence: true,
        confirmation: true, 
        length: { minimum: 10 },
        format: {
            with: VALID_PASSWORD_REGEX,
            message: 'must be at least 10 characters long and include at least an uppercase letter, a number, and a special character (!@#$%^&*).'
        }
end

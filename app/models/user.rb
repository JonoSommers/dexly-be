class User < ApplicationRecord
    has_secure_password
    VALID_PASSWORD_REGEX = /\A(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*]).{8,}\z/
    has_many :user_binders, dependent: :destroy
    has_many :binders, through: :user_binders

    validates :username, presence: true, uniqueness: true
    validates :password, 
        presence: true, 
        length: { minimum: 10 },
        format: {
            with: VALID_PASSWORD_REGEX,
            message: 'Password must be at least 10 characters long and include at least 1 upeercase letter, 1 number, and 1 special character (!@#$%^&*).'
        }
end

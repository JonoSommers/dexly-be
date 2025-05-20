class Binder < ApplicationRecord
    has_many :user_binders, dependent: :destroy
    has_many :users, through: :user_binders

    has_many :binder_cards, dependent: :destroy
    has_many :cards, through: :binder_cards
end

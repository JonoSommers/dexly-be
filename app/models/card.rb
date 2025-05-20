class Card < ApplicationRecord
    has_many :binder_cards
    has_many :binders, through: :binder_cards
end

class Card < ApplicationRecord
    self.primary_key = :id

    has_many :binder_cards
    has_many :binders, through: :binder_cards

    validates :id, presence: true, uniqueness: true
    validates :name, presence: true
    validates :set_name, presence: true
    validates :image_url, presence: true
end

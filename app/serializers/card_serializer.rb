class CardSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :set_name, :image_url, :subtype, :supertype, :rarity, :types
end

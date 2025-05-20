class CardSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :set_name, :image_url, :supertype, :rarity, :types
end

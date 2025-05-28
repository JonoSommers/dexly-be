class BinderSerializer
    include JSONAPI::Serializer
    attributes :name, :cover_image_url

    attribute :cards do |binder|
        binder.cards.map do |card|
            {
                id: card.id,
                name: card.name,
                set_name: card.set_name,
                image_url: card.image_url,
                subtype: card.subtype,
                supertype: card.supertype,
                rarity: card.rarity,
                types: card.types
            }
        end
    end
end

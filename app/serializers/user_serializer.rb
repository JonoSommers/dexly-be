class UserSerializer
    include JSONAPI::Serializer
    attributes :username

    attribute :binders do |user|
        user.binders.map do |binder|
            {
                id: binder.id,
                name: binder.name,
                cover_image_url: binder.cover_image_url
            }
        end
    end
end

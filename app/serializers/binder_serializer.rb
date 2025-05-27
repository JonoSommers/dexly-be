class BinderSerializer
    include JSONAPI::Serializer
    attributes :name, :cover_image_url
end

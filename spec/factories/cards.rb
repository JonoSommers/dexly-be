FactoryBot.define do
  factory :card do
    sequence(:id) { |n| "sv1-#{n}" }
    name { "Testmon" }
    set_name { "Test Set" }
    image_url { "https://example.com/testmon.png" }
    supertype { "Pokémon" }
    subtype { "Basic" }
    rarity { "Rare" }
    types { "Fire" }
  end
end

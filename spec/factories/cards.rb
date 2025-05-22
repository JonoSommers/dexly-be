FactoryBot.define do
  factory :card do
    sequence(:id) { |n| "set#{rand(1..10)}-#{n}" }
    name { Faker::Games::Pokemon.name }
    set_name { ["Base Set", "Jungle", "Fossil", "Neo Genesis", "EX Team Rocket", "SV Black Star"].sample }
    image_url { Faker::Internet.url }
    supertype { ["Pokémon", "Trainer", "Energy"].sample }
    subtype { ["Basic", "Stage 1", "Stage 2", "Supporter", "Item", nil].sample }
    rarity { ["Common", "Uncommon", "Rare", "Ultra Rare", "Secret Rare", nil].sample }
    types { ["Fire", "Water", "Grass", "Electric", "Psychic", "Dark", "Fairy", "Dragon", "Steel", nil].compact.sample }
  end
end


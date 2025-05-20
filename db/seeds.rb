# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'httparty'

class PokemonCardSeeder
    include HTTParty
    base_uri 'https://api.pokemontcg.io/v2'

    def initialize
        @headers = {
        "X-Api-Key" => ENV["POKEMON_API_KEY"]
        }
    end

    def seed_all_cards
        page = 1
        page_size = 250
        total_cards = nil

        loop do
            response = self.class.get("/cards", headers: @headers, query: { page: page, pageSize: page_size })

            break unless response.success?

            cards = response.parsed_response["data"]
            total_cards ||= response.parsed_response["totalCount"]

            cards.each do |card_data|
                Card.find_or_create_by!(id: card_data["id"]) do |card|
                    card.name       = card_data["name"]
                    card.set_name   = card_data.dig("set", "name")
                    card.image_url  = card_data.dig("images", "small")
                    card.supertype  = card_data["supertype"]
                    card.subtype    = card_data["subtypes"]&.first
                    card.rarity     = card_data["rarity"]
                    card.types      = card_data["types"]&.join(", ")
                end
            end

            puts "Seeded page #{page} of #{(total_cards / page_size.to_f).ceil}"
            page += 1
            break if cards.empty?
        end
    end
end

# Kick it off
PokemonCardSeeder.new.seed_all_cards

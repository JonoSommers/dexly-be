require 'rails_helper'

RSpec.describe "Cards API", type: :request do
    before do
        create(:card, name: "Snorlax", set_name: "Base Set")
        create_list(:card, 50)
    end

    describe "GET /api/v1/cards Happy Paths" do
        context "card ordering" do
            it "always orders cards by set_name then card number" do
                Card.destroy_all

                create(:card, id: "b-2", set_name: "Set B")
                create(:card, id: "a-3", set_name: "Set A")
                create(:card, id: "a-1", set_name: "Set A")
                create(:card, id: "b-1", set_name: "Set B")
                create(:card, id: "a-2", set_name: "Set A")

                get api_v1_cards_path

                json = JSON.parse(response.body, symbolize_names: true)

                card_ids = json[:data].map { |c| c[:id] }

                expect(card_ids).to eq([ "a-1", "a-2", "a-3", "b-1", "b-2" ])
            end
        end

        context "when no params are provided" do
            it "returns the first page of cards with 16 results" do
                get api_v1_cards_path

                expect(response).to be_successful

                json = JSON.parse(response.body, symbolize_names: true)
                first_card = json[:data].first

                expect(json[:data].count).to eq(16)
                expect(json[:meta]).to include(:current_page, :total_pages, :total_count)
                expect(json[:meta][:current_page]).to eq(1)
                expect(first_card).to include(:id, :type, :attributes)
                expect(first_card[:type]).to eq("card")
                expect(first_card[:attributes]).to include(
                    id: anything,
                    name: anything,
                    set_name: anything,
                    image_url: anything,
                    supertype: anything,
                    subtype: anything,
                    rarity: anything,
                    types: anything
                )
            end
        end

        context "when requesting a specific page" do
            it "returns the correct set of cards for that page" do
                get api_v1_cards_path, params: { page: "3" }

                expect(response).to be_successful

                json = JSON.parse(response.body, symbolize_names: true)

                expect(json[:data].count).to eq(16)
                expect(json[:meta]).to include(:current_page, :total_pages, :total_count)
                expect(json[:meta][:current_page]).to eq(3)
            end
        end

        context "when a name filter is applied" do
            it "returns cards matching the name" do
                get api_v1_cards_path, params: { name: "Snorlax" }

                expect(response).to be_successful

                json = JSON.parse(response.body, symbolize_names: true)

                expect(json[:data].count).to be >= 1
                expect(json[:data].first[:attributes][:name]).to match(/Snorlax/i)
            end

            it "returns cards that partially match the name filter" do
                get api_v1_cards_path, params: { name: "Sno" }

                expect(response).to be_successful

                json = JSON.parse(response.body, symbolize_names: true)

                expect(json[:data].count).to be >= 1
                expect(json[:data].first[:attributes][:name]).to include("Sno")
            end
        end

        context "when a set_name filter is applied" do
            it "returns the cards from the correct set" do
                get api_v1_cards_path, params: { set: "Base Set" }

                expect(response).to be_successful

                json = JSON.parse(response.body, symbolize_names: true)

                expect(json[:data].count).to be >= 1
                expect(json[:data].first[:attributes][:set_name]).to match(/Base Set/i)
            end

            it "returns cards that partially match the set_name filter" do
                get api_v1_cards_path, params: { set: "Bas" }

                expect(response).to be_successful

                json = JSON.parse(response.body, symbolize_names: true)

                expect(json[:data].count).to be >= 1
                expect(json[:data].first[:attributes][:set_name]).to include("Bas")
            end
        end

        context "when both name and set filters are applied" do
            it "returns only cards that match both conditions" do
                Card.destroy_all

                create(:card, name: "Pikachu", set_name: "Jungle")
                create(:card, name: "Pikachu", set_name: "Base Set")
                create(:card, name: "Charizard", set_name: "Jungle")

                get api_v1_cards_path, params: { name: "Pikachu", set: "Jungle" }

                json = JSON.parse(response.body, symbolize_names: true)

                expect(json[:data].count).to eq(1)
                expect(json[:data].first[:attributes][:name]).to eq("Pikachu")
                expect(json[:data].first[:attributes][:set_name]).to eq("Jungle")
            end
        end
    end

    describe "GET /api/v1/cards Sad Paths" do
        context "when no cards match the name filter" do
            it "returns an empty data array with status 200" do
                get api_v1_cards_path, params: { name: "Test Name" }

                expect(response).to be_successful

                json = JSON.parse(response.body, symbolize_names: true)

                expect(response.status).to eq(200)
                expect(json[:data].count).to eq(0)
            end
        end

        context "when no cards match the set_name filter" do
            it "returns an empty data array with status 200" do
                get api_v1_cards_path, params: { set: "Test Set" }

                expect(response).to be_successful

                json = JSON.parse(response.body, symbolize_names: true)

                expect(response.status).to eq(200)
                expect(json[:data].count).to eq(0)
            end
        end

        context "when an invalid page param is provided" do
            it "defaults to page 1" do
                get api_v1_cards_path, params: { page: "abc" }

                expect(response).to be_successful
                json = JSON.parse(response.body, symbolize_names: true)

                expect(json[:meta][:current_page]).to eq(1)
            end
        end
    end
end

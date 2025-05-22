require 'rails_helper'

RSpec.describe "Cards API", type: :request do
    before do
        create_list(:card, 50)
    end

    describe "GET /api/v1/cards Happy Paths" do
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

                expect(json[:data].count).to eq(16)
                expect(json[:meta]).to include(:current_page, :total_pages, :total_count)
                expect(json[:meta][:current_page]).to eq(3)
            end
        end

        context "when a set_name filter is applied" do
            it "returns the cards from the correct set" do
            end
        end
    end

    describe "GET /api/v1/cards Sad Paths" do
        context "when no cards match the filter" do
            it "returns an empty data array with status 200" do
            end
        end
    end
end
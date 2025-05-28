require 'rails_helper'

RSpec.describe "BinderCards API", type: :request do
    let!(:user) { create(:user) }
    let!(:binder) { create(:binder) }
    let!(:card) { create(:card) }
    let!(:user_binder) { create(:user_binder, user: user, binder: binder) }

    describe "POST /api/v1/users/:user_id/binders/:binder_id/binder_cards Happy Path" do
        context "when valid user, binder, and card IDs are provided" do
            it "adds a card to the binder and returns the updated binder" do
                post api_v1_user_binder_binder_cards_path(user.id, binder.id), params: { card_id: card.id }

                expect(response).to have_http_status(:created)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:data][:attributes][:cards]).to be_an(Array)
                expect(json[:data][:attributes][:cards].first[:id]).to eq(card.id)
            end
        end
    end

    describe "POST /api/v1/users/:user_id/binders/:binder_id/binder_cards Sad Paths" do
        context "when the user does not exist" do
            it "returns a 404 error" do
                post api_v1_user_binder_binder_cards_path(9999, binder.id), params: { card_id: card.id }

                expect(response).to have_http_status(:not_found)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:errors].first).to match(/Couldn't find User/)
            end
        end

        context "when the binder is not associated with the user" do
            let!(:other_user) { create(:user) }

            it "returns a 404 error" do
                post api_v1_user_binder_binder_cards_path(other_user.id, binder.id), params: { card_id: card.id }

                expect(response).to have_http_status(:not_found)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:errors].first).to match(/Couldn't find Binder/)
            end
        end

        context "when the card ID is missing" do
            it "returns a 404 error" do
                post api_v1_user_binder_binder_cards_path(user.id, binder.id)

                expect(response).to have_http_status(:not_found)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:errors].first).to match(/Couldn't find Card without an ID/)
            end
        end

        context "when the card does not exist" do
            it "returns a 404 error" do
                post api_v1_user_binder_binder_cards_path(user.id, binder.id), params: { card_id: 9999 }

                expect(response).to have_http_status(:not_found)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:errors].first).to match(/Couldn't find Card/)
            end
        end
    end

    describe "DELETE /api/v1/users/:user_id/binders/:binder_id/binder_cards/:id Happy Path" do
        let!(:binder_card) { create(:binder_card, binder: binder, card: card) }

        it "removes the card from the binder and returns the updated binder" do
            delete api_v1_user_binder_binder_card_path(user.id, binder.id, binder_card.id)

            expect(response).to have_http_status(:ok)

            json = JSON.parse(response.body, symbolize_names: true)
            card_ids = json[:data][:attributes][:cards].map { |c| c[:id] }
            expect(card_ids).not_to include(card.id)
        end
    end

    describe "DELETE /api/v1/users/:user_id/binders/:binder_id/binder_cards/:id Sad Paths" do
        let!(:binder_card) { create(:binder_card, binder: binder, card: card) }

        it "returns 404 if user is invalid" do
            delete api_v1_user_binder_binder_card_path(9999, binder.id, binder_card.id)

            expect(response).to have_http_status(:not_found)

            json = JSON.parse(response.body, symbolize_names: true)
            expect(json[:errors].first).to match(/Couldn't find User/)
        end

        it "returns 404 if binder is invalid for user" do
            other_user = create(:user)
            delete api_v1_user_binder_binder_card_path(other_user.id, binder.id, binder_card.id)

            expect(response).to have_http_status(:not_found)

            json = JSON.parse(response.body, symbolize_names: true)
            expect(json[:errors].first).to match(/Couldn't find Binder/)
        end

        it "returns 404 if binder_card ID is invalid" do
            delete api_v1_user_binder_binder_card_path(user.id, binder.id, 9999)

            expect(response).to have_http_status(:not_found)

            json = JSON.parse(response.body, symbolize_names: true)
            expect(json[:errors].first).to match(/Couldn't find BinderCard/)
        end
    end
end

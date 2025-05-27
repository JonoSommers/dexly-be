require 'rails_helper'

RSpec.describe "Binders API", type: :request do
    let!(:user) { create(:user) }

    describe "POST /api/v1/users/:user_id/binders Happy Paths" do
        context "when valid parameters are provided" do
            it "creates a new binder and associates it with the user" do
                binder_params = {
                    name: "Electric Cards",
                    cover_image_url: ""
                }

                post api_v1_user_binders_path(user), params: binder_params

                expect(response).to have_http_status(:created)

                json = JSON.parse(response.body, symbolize_names: true)

                expect(json[:data]).to include(:id, :type, :attributes)
                expect(json[:data][:type]).to eq("binder")
                expect(json[:data][:attributes][:name]).to eq("Electric Cards")
                expect(json[:data][:attributes][:cover_image_url]).to eq("")
            end

            it "creates a binder when cover_image_url is omitted" do
                binder_params = {
                    name: "Trainer Binder"
                }

                post api_v1_user_binders_path(user), params: binder_params

                expect(response).to have_http_status(:created)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:data][:attributes][:cover_image_url]).to be_nil
            end
        end
    end

    describe "POST /api/v1/users/:user_id/binders Sad Paths" do
        context "when the name is missing or blank" do
            it "returns a 422 error if name is missing" do
                binder_params = {
                    cover_image_url: "https://img.png"
                }

                post api_v1_user_binders_path(user), params: binder_params

                expect(response).to have_http_status(:unprocessable_entity)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:errors].first).to match(/Name can't be blank/)
            end

            it "returns a 422 error if name is blank" do
                binder_params = {
                    name: "",
                    cover_image_url: "https://img.png"
                }

                post api_v1_user_binders_path(user), params: binder_params

                expect(response).to have_http_status(:unprocessable_entity)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:errors].first).to match(/Name can't be blank/)
            end
        end

        context "when the user_id is invalid" do
            it "returns a 404 error" do
                binder_params = {
                    name: "Lost Binder",
                    cover_image_url: ""
                }

                post api_v1_user_binders_path(user_id: 9999), params: binder_params

                expect(response).to have_http_status(:not_found)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:errors].first).to match(/Couldn't find User/)
            end
        end
    end
end
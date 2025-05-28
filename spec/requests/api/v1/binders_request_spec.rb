require 'rails_helper'

RSpec.describe "Binders API", type: :request do
    let!(:user) { create(:user) }
    let!(:binder) { create(:binder) }

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

    describe "DELETE /api/v1/users/:user_id/binders/:id Happy Paths" do
        let!(:user_binder) { create(:user_binder, user: user, binder: binder) }

        context "when binder exists and is associated with a user" do
            it "deletes the specified binder and returns a 204" do
                delete api_v1_user_binder_path(user.id, binder.id)

                expect(response).to have_http_status(:no_content)
                expect(Binder.find_by(id: binder.id)).to be_nil
            end
        end
    end

    describe "DELETE /api/v1/users/:user_id/binders/:id Sad Paths" do
        let!(:user_binder) { create(:user_binder, user: user, binder: binder) }

        context "when a binder does not exist or user is invalid" do
            it "returns a 404 if the binder does not exist" do
                delete api_v1_user_binder_path(user.id, 99999)

                expect(response).to have_http_status(:not_found)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:errors].first).to eq("Couldn't find Binder with 'id'=99999 [WHERE \"user_binders\".\"user_id\" = $1]")
            end

            it "returns a 404 if the user is invalid" do
                delete api_v1_user_binder_path(99999, binder.id)

                expect(response).to have_http_status(:not_found)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:errors].first).to eq("Couldn't find User with 'id'=99999")
            end
        end
    end

    describe "PATCH /api/v1/users/:user_id/binders/:id Happy Paths" do
        let!(:user_binder) { create(:user_binder, user: user, binder: binder) }

        context "when valid update params are provided" do
            it "updates a binder's name and/or cover_image_url" do
                patch api_v1_user_binder_path(user.id, binder.id), params: {
                    new_name: "New Binder Name",
                    new_image: "https://new.image.url"
                }

                expect(response).to have_http_status(:ok)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:data][:attributes][:name]).to eq("New Binder Name")
                expect(json[:data][:attributes][:cover_image_url]).to eq("https://new.image.url")
            end
        end
    end

    describe "PATCH /api/v1/users/:user_id/binders/:id Sad Paths" do
        let!(:user_binder) { create(:user_binder, user: user, binder: binder) }

        context "when update params are missing or blank" do
            it "returns a 422 if name is blank" do
                patch api_v1_user_binder_path(user.id, binder.id), params: { name: "" }

                expect(response).to have_http_status(:unprocessable_entity)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:errors].first).to match(/Name can't be blank/)
            end

            it "returns a 422 if name is missing" do
                patch api_v1_user_binder_path(user.id, binder.id), params: { cover_image_url: "https://img.png" }

                expect(response).to have_http_status(:unprocessable_entity)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:errors].first).to match(/Name can't be blank/)
            end
        end

        context "when user or binder are invalid" do
            it "returns a 404 if binder is not associated with the user" do
                other_user = create(:user)
                patch api_v1_user_binder_path(other_user.id, binder.id), params: { name: "Test Binder" }

                expect(response).to have_http_status(:not_found)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:errors].first).to match(/Couldn't find Binder/)
            end

            it "returns a 404 if user does not exist" do
                patch api_v1_user_binder_path(99999, binder.id), params: { name: "Ghost Binder" }

                expect(response).to have_http_status(:not_found)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:errors].first).to match(/Couldn't find User/)
            end
        end
    end
end

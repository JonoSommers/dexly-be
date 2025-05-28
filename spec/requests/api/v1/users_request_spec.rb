require 'rails_helper'

RSpec.describe "Users API", type: :request do
    describe "POST /api/v1/users Happy Paths" do
        context "when valid credentials are provided" do
            it "creates a new user" do
                post api_v1_users_path, params: {
                    username: "AshKetchum",
                    password: "pikachu12345",
                    password_confirmation: "pikachu12345"
                }

                expect(response).to have_http_status(:created)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json).to have_key(:data)
                expect(json[:data]).to include(:id, :type, :attributes)
                expect(json[:data][:type]).to eq("user")
                expect(json[:data][:attributes]).to include(username: "AshKetchum")
                expect(json[:data][:attributes]).to have_key(:binders)
                expect(json[:data][:attributes][:binders]).to eq([])
            end
        end
    end

    describe "POST /api/v1/users Sad Paths" do
        context "when username is already taken" do
            it "returns a 422 status with an error message" do
                create(:user, username: "AshKetchum")

                post api_v1_users_path, params: {
                    username: "AshKetchum",
                    password: "pikachu12345",
                    password_confirmation: "pikachu12345"
                }

                expect(response).to have_http_status(:unprocessable_entity)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:errors]).to include("Username has already been taken")
            end
        end

        context "when passwords do not match" do
            it "returns a 422 status with an error message" do
                post api_v1_users_path, params: {
                    username: "Misty",
                    password: "water12345",
                    password_confirmation: "mistyrocks"
                }

                expect(response).to have_http_status(:unprocessable_entity)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:errors]).to include("Password confirmation doesn't match Password")
            end
        end

        context "when password is too short" do
            it "returns a 422 status with an error message" do
                post api_v1_users_path, params: {
                    username: "Brock",
                    password: "short",
                    password_confirmation: "short"
                }

                expect(response).to have_http_status(:unprocessable_entity)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:errors]).to include("Password is too short (minimum is 10 characters)")
            end
        end

        context "when a required field is missing" do
            it "returns a 422 status with an error message" do
                post api_v1_users_path, params: {
                    password: "missinguser123",
                    password_confirmation: "missinguser123"
                }

                expect(response).to have_http_status(:unprocessable_entity)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:errors]).to include("Username can't be blank")
            end
        end
    end

    describe "GET /api/v1/users/:id Happy Paths" do
        context "when the user exists" do
            let!(:user) { create(:user) }
            let!(:binder) { create(:binder) }
            let!(:user_binder) { create(:user_binder, user: user, binder: binder) }

            it "returns the user's data" do
                get api_v1_user_path(user.id)

                expect(response).to have_http_status(:ok)

                json = JSON.parse(response.body, symbolize_names: true)

                expect(json[:data][:attributes][:username]).to eq(user.username)
                expect(json[:data][:attributes]).to have_key(:binders)
                expect(json[:data][:attributes][:binders]).to be_an(Array)
                expect(json[:data][:attributes][:binders].first).to include(
                    id: binder.id,
                    name: binder.name,
                    cover_image_url: binder.cover_image_url
                )
            end
        end
    end

    describe "GET /api/v1/users/:id Sad Paths" do
        context "when the user does not exist" do
            it "returns a 404 error with a message" do
                get api_v1_user_path(999999)

                expect(response).to have_http_status(:not_found)

                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:errors]).to eq([ "Couldn't find User with 'id'=999999" ])
            end
        end
    end
end

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
end

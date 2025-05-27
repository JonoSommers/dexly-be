require 'rails_helper'

RSpec.describe "Users API", type: :request do

    describe "POST /api/v1/users Happy Paths" do
        context "when valid credentials are provided" do
            it "creates a new user" do
                user_params = {
                    username: "AshKetchum",
                    password: "pika_power123",
                    password_confirmation: "pika_power123"
                }

                post api_v1_users_path, params: user_params

                expect(response).to be_successful
                expect(response).to have_http_status(:created)

                json = JSON.parse(response.body, symbolize_names: true)

                expect(json).to have_key(:data)
                expect(json[:data]).to include(:id, :type, :attributes)
                expect(json[:data][:type]).to eq("user")
                expect(json[:data][:attributes]).to include( username: "AshKetchum")
            end
        end
    end
end
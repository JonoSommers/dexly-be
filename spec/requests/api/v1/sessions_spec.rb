require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do
    describe 'POST /api/v1/login' do
        let!(:user) { User.create!(username: 'ash', password: 'pikachu123') }

        context 'with valid credentials' do
            it 'returns the user and status 200' do
                post '/api/v1/login', params: { username: 'ash', password: 'pikachu123' }

                expect(response).to have_http_status(:ok)
                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:username]).to eq('ash')
            end
        end

        context 'with incorrect password' do
            it 'returns unauthorized and an error message' do
                post '/api/v1/login', params: { username: 'ash', password: 'wrong' }

                expect(response).to have_http_status(:unauthorized)
                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:error]).to eq('Invalid username or password')
            end
        end

        context 'with non-existent username' do
            it 'returns unauthorized and an error message' do
                post '/api/v1/login', params: { username: 'misty', password: 'staryu' }

                expect(response).to have_http_status(:unauthorized)
                json = JSON.parse(response.body, symbolize_names: true)
                expect(json[:error]).to eq('Invalid username or password')
            end
        end

        context 'with missing credentials' do
            it 'returns unauthorized when username is missing' do
                post '/api/v1/login', params: { password: 'pikachu123' }

                expect(response).to have_http_status(:unauthorized)
            end

            it 'returns unauthorized when password is missing' do
                post '/api/v1/login', params: { username: 'ash' }

                expect(response).to have_http_status(:unauthorized)
            end
        end
    end
end

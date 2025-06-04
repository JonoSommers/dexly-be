class Api::V1::SessionsController < ApplicationController
    def create
        username = params[:username]
        password = params[:password]

        unless username.present? && password.present?
            return render json: { error: 'Username and password are required' }, status: :unauthorized
        end

        user = User.find_by(username: username)

            if user&.authenticate(password)
                render json: user, status: :ok
            else
            render json: { error: 'Invalid username or password' }, status: :unauthorized
        end
    end
end


class Api::V1::SessionsController < ApplicationController
    def create
        username = params[:username]
        password = params[:password]

        unless username.present? && password.present?
            return render json: { error: "Username and password are required" }, status: :unauthorized
        end

        user = User.find_by(username: username)

            if user&.authenticate(password)
                session[:user_id] = user.id 
                render json: UserSerializer.new(user), status: :ok
            else
            render json: { error: "Invalid username or password" }, status: :unauthorized
            end
    end

    def show
        if session[:user_id]
            user = User.find_by(id: session[:user_id])
            if user
                render json: UserSerializer.new(user), status: :ok
            end
        else
            render json: { error: "No active session" }, status: :unauthorized
        end
    end

    def destroy
        session[:user_id] = nil
        head :no_content
    end
end

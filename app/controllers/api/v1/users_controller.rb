class Api::V1::UsersController < ApplicationController
    def show
        render json: UserSerializer.new(User.find(params[:id])), status: :ok
    end

    def create
        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: UserSerializer.new(user), status: :created
    end

    private

    def user_params
        params.permit(:username, :password, :password_confirmation)
    end
end

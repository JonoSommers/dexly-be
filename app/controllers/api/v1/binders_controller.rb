class Api::V1::BindersController < ApplicationController
    def create
        user = User.find(params[:user_id])
        binder = user.binders.create!(binder_params)
        render json: BinderSerializer.new(binder), status: :created
    end

    def update
        user = User.find(params[:user_id])
        binder = user.binders.find(params[:id])
        binder.update!(name: params[:new_name], cover_image_url: params[:new_image])
        render json: BinderSerializer.new(binder), status: :ok
    end

    def destroy
        user = User.find(params[:user_id])
        binder = user.binders.find(params[:id])
        binder.destroy
        head :no_content
    end

    private

    def binder_params
        params.permit(:name, :cover_image_url)
    end
end

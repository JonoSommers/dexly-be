class Api::V1::BinderCardsController < ApplicationController
    def create
        user = User.find(params[:user_id])
        binder = user.binders.find(params[:binder_id])
        card = Card.find(params[:card_id])
        binder_card = BinderCard.create!(binder_id: binder.id, card_id: card.id)
        render json: BinderSerializer.new(binder), status: :created
    end
end
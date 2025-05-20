class Api::V1::CardsController < ApplicationController
    def index
        cards = Card.order(:set_name).order(Arel.sql("CAST(SPLIT_PART(id, '-', 2) AS INTEGER)"))
        cards = cards.where("name ILIKE ?", "%#{params[:name]}%") if params[:name]
        cards = cards.where("set_name ILIKE ?", "%#{params[:set]}%") if params[:set]
        paginated = cards.page(params[:page]).per(params[:per_page] || 16)
        render_with_meta(paginated, CardSerializer)
    end
end

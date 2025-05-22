class Api::V1::CardsController < ApplicationController
    def index
        cards = Card.order(:set_name).order(
            Arel.sql("NULLIF(regexp_replace(id, '\\D', '', 'g'), '')::INT NULLS LAST")
        )
        cards = cards.where("name ILIKE ?", "%#{params[:name]}%") if params[:name]
        cards = cards.where("set_name ILIKE ?", "%#{params[:set]}%") if params[:set]
        paginated = cards.page(sanitized_page).per(16)
        render_with_meta(paginated, CardSerializer)
    end
end

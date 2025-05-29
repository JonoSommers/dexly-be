class Api::V1::CardsController < ApplicationController
    def index
        cards = Card.order(:set_name).order(
            Arel.sql("NULLIF(regexp_replace(id, '\\D', '', 'g'), '')::INT NULLS LAST")
        )

        if params[:name].present? || params[:set].present?
            cards = cards.where("name ILIKE ?", "%#{params[:name]}%") if params[:name]
            cards = cards.where("set_name ILIKE ?", "%#{params[:set]}%") if params[:set]
            paginated = cards.page(sanitized_page).per(16)
        else
            paginated = Rails.cache.fetch("cards:page:#{sanitized_page}", expires_in: 12.hours) do
                cards.page(sanitized_page).per(16).to_a
            end

            paginated = Kaminari.paginate_array(paginated, total_count: cards.count).page(sanitized_page).per(16)
        end

        render_with_meta(paginated, CardSerializer)
    end
end

class ApplicationController < ActionController::API
    def render_with_meta(records, serializer)
        render json: serializer.new(records).serializable_hash.merge({
            meta: {
                current_page: records.current_page,
                total_pages: records.total_pages,
                total_count: records.total_count
            }
        })
    end

    private

    def sanitized_page
        return 1 unless params[:page].to_s.match?(/\A\d+\z/)
        page = params[:page].to_i
        page > 0 ? page : 1
    end
end

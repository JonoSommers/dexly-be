class ApplicationController < ActionController::API
    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
    rescue_from ActionController::ParameterMissing, with: :handle_missing_param

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

    def handle_record_invalid(error)
        render json: { errors: error.record.errors.full_messages }, status: :unprocessable_entity
    end

    def handle_record_not_found(error)
        render json: { errors: [ error.message ] }, status: :not_found
    end

    def handle_missing_param(error)
        render json: { errors: [error.message] }, status: :bad_request
    end

    def sanitized_page
        return 1 unless params[:page].to_s.match?(/\A\d+\z/)
        page = params[:page].to_i
        page > 0 ? page : 1
    end
end

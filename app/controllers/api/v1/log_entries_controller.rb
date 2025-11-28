# app/controllers/api/v1/log_entries_controller.rb
module Api
  module V1
    class LogEntriesController < ApplicationController
      def index
        # sleep 1 # testing the Skeleton Screen loading state

        # 1. Base Scope: Always ensure deterministic ordering for logs
        logs = LogEntry.order(timestamp: :desc)

        # 2. Filtering
        if params[:severity].present?
          logs = logs.where(severity: params[:severity])
        end

        # 3. Pagination (With Safety Guards)
        page = params[:page].to_i
        page = 1 if page < 1

        per_page = params[:per_page].to_i
        per_page = 50 if per_page < 1 || per_page > 100 # Add a max limit to prevent abuse

        # 4. Fetch Data
        offset = (page - 1) * per_page
        @logs = logs.limit(per_page).offset(offset)

        # 5. Render
        render json: {
          data: @logs,
          meta: {
            current_page: page,
            per_page: per_page,
            total_count: logs.count, # Note: On massive tables, count(*) is slow. In real life, we'd estimate this.
            total_pages: (logs.count.to_f / per_page).ceil
          }
        }
      end
    end
  end
end

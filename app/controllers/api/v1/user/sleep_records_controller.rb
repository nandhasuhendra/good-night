module API
  module V1
    module User
      class SleepRecordsController < ApplicationController
        def create
          @result = ::SleepRecords::ClockInService.call(current_user)
          unless @result.success?
            render json: { errors: @result.result }, status: :unprocessable_entity
            return
          end

          @result = @result.result[:record]
        end

        def update
          @result = ::SleepRecords::ClockOutService.call(current_user)
          unless @result.success?
            render json: { errors: @result.result }, status: :unprocessable_entity
            return
          end

          @result = @result.result[:record]
        end
      end
    end
  end
end

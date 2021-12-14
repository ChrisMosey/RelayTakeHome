require 'net/http'


class ExchangeController < ApplicationController
    extend Limiter::Mixin

    # Exception Handling
    class NotCurrencyError < StandardError
    end
    class ExchangeError < StandardError
    end
    class ProcessingError < StandardError
    end

    limit_method :get_exchange_rate, rate: 300

    EXCHANGE_URL = "https://open.exchangerate-api.com/v6"
    ACCESS_KEY = "23d6a8eac79a95f84f3a0dcf" # Remove before pushing
    EXCHANGE_URL_WITH_KEY = "https://v6.exchangerate-api.com/v6/#{ACCESS_KEY}"

    CURRENCY_CHECK = /^\d+\.\d\d$/

    def all_rates()
        result = JSON.parse(Net::HTTP.get(URI.parse("#{EXCHANGE_URL}/latest")))
        render json: result["rates"]
    end

    def get_exchange_rate()
        from_currency = params[:from_currency]
        to_currency = params[:to_currency]
        amount = params[:amount]

        raise NotCurrencyError unless amount.match? CURRENCY_CHECK
        
        begin
            result = JSON.parse(
                Net::HTTP.get(
                    URI.parse("#{EXCHANGE_URL_WITH_KEY}/pair/#{from_currency}/#{to_currency}/#{amount}")
                )
            )
        rescue
            raise ExchangeError
        end
        
        raise ProcessingError if result["result"] == "error"

        return_json = {
            conversion_rate: result["conversion_rate"],
            conversion_result: result["conversion_result"]
        }

        render json: return_json, status: 200

    rescue NotCurrencyError
        render json: { message: "amount can only be an number with 2 decimal places" }, status: 401
    rescue ExchangeError
        render json: { message: "invalid exchange, or the exchange server is down" }, status: 500
    rescue ProcessingError
        render json: { message: "error processing your request" }, status: 422
    end
end

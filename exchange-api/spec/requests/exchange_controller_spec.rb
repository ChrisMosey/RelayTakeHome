require 'rails_helper'

RSpec.describe "ExchangeControllers", type: :request do
  describe "GET /all_rates" do
    it "should get all rates" do
      get "http://localhost:3000/all_rates"
      body = JSON.parse(response.body)

      assert_equal 1, body["USD"]
    end
  end

  describe "GET /get_exchange_rate" do
    it "should fail if currency field is a string" do
      get "http://localhost:3000/get_exchange_rate", params: { 
        from_currency: "cad",
        to_currency: "usd",
        amount: "TEST",
      }

      assert_response 401
    end

    it "should fail if currency field has too many decimal places" do
      get "http://localhost:3000/get_exchange_rate", params: { 
        from_currency: "cad",
        to_currency: "usd",
        amount: 123.33333,
      }

      assert_response 401
    end

    it "should fail if currency field does not have decimal place" do
      get "http://localhost:3000/get_exchange_rate", params: { 
        from_currency: "cad",
        to_currency: "usd",
        amount: 123,
      }

      assert_response 401
    end

    it "should fail if from_currency is not a string" do
      get "http://localhost:3000/get_exchange_rate", params: { 
        from_currency: 123,
        to_currency: "usd",
        amount: 12.01,
      }

      assert_response 500
    end

    it "should fail if to_currency is not a string" do
      get "http://localhost:3000/get_exchange_rate", params: { 
        from_currency: "cad",
        to_currency: 123,
        amount: 12.01,
      }

      assert_response 500
    end

    it "should fail if from_currency is not a listed currency" do
      get "http://localhost:3000/get_exchange_rate", params: { 
        from_currency: "xxx",
        to_currency: "usd",
        amount: 12.01,
      }

      assert_response 422
    end

    it "should fail if to_currency is not a listed currency" do
      get "http://localhost:3000/get_exchange_rate", params: { 
        from_currency: "cad",
        to_currency: "xxx",
        amount: 12.01,
      }

      assert_response 422
    end

    it "should return the converted currency" do
      get "http://localhost:3000/get_exchange_rate", params: { 
        from_currency: "cad",
        to_currency: "usd",
        amount: 12.01,
      }

      body = JSON.parse(response.body)

      assert body["conversion_rate"]
      assert body["conversion_result"]
    end
  end
end

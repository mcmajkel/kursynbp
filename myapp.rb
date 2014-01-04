require "sinatra"
require "sinatra/json"
require "json"
require_relative "lib/currency_provider.rb"

get '/api/:date,:currency.json' do
  content_type :json
  date = params[:date]
  currency = params[:currency]
  result = CurrencyProvider.get_exchange_rate(date, currency)

  result.to_json
end
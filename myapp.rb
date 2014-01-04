require "sinatra"
require 'net/http'
require 'open-uri'
require "nokogiri"
require "sinatra/json"
require "json"

get '/' do
  'oh hi'
end

get '/:date,:symbol.json' do
  content_type :json

  @date = params[:date]
  @symbol = params[:symbol]
  @url = "http://www.nbp.pl/kursy/xml/"
  pattern = Regexp.new "a\\d{3}z#{@date}"
  begin
    data = Net::HTTP.get(URI(@url+'dir.txt'))
    match = pattern.match(data)
    raise "Ups... file not found. Try again later." if match.nil?
    @filename = "#{match}.xml"
    source_uri = @url + @filename
    doc = Nokogiri::XML(open(source_uri))
    raise "XML not found" if doc.nil?
    kurs = doc.xpath("//pozycja[kod_waluty='#{@symbol}']/kurs_sredni").text
    raise "Waluta not found" if kurs.empty?
    @result = 1
  rescue Exception => e
    puts e.message
    @error = e.message
    @result = 0
  end

  {response: @result, result: (@result == 0 ? @error.to_s : kurs), params: {date: @date, currency: @symbol.to_s}}.to_json
end
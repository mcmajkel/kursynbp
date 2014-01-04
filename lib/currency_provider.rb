require "date"
require 'net/http'
require 'open-uri'
require "nokogiri"

class CurrencyProvider
  URL_NBP = "http://www.nbp.pl/kursy/xml/"

  def self.get_exchange_rate(date, symbol, as_float = false)

    xpath_def = "//pozycja[kod_waluty='#{symbol}']/kurs_sredni"
    begin
      date = Date.parse(date).strftime('%y%m%d') rescue nil
      raise_error(1) unless date

      currency_pattern = Regexp.new "a\\d{3}z#{date}"
      data = Net::HTTP.get(URI(URL_NBP+'dir.txt'))
      match = currency_pattern.match(data)

      unless match.nil?
        filename = "#{match}.xml"
      else
        raise_error(10)
      end

      source_uri = URL_NBP + filename
      nbp_exch_rate_file = Nokogiri::XML(open(source_uri))

      unless nbp_exch_rate_file.nil?
        exchange_rate = nbp_exch_rate_file.xpath(xpath_def).text
        raise_error(20) if exchange_rate.empty?
        exchange_rate = exchange_rate.gsub!(/,/) { '.' }.to_f if as_float
      else
        raise_error(30)
      end

      return result = {code: 100, message: 'OK', exchange: exchange_rate}

    rescue Exception => e
      puts e.message
      return {code: @result_code, message: e.message, exchange: nil}
    end

  end

  private
  attr_reader :result_code

  def self.raise_error(code)
    @result_code = code
    raise get_error_message(code)
  end

  def self.get_error_message(code)
    case code
    when 1
      message = "Ups... Date format not proper"
    when 10
      message = "Ups... file not found (probably not published yet)."
    when 20
      message = "Ups... Given currency not found"
    when 30
      message = "Ups... XML file not found (blame NBP!)"
    else
      message = "Ups... Unknown error."
    end
  end

end
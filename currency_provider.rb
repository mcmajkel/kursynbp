class CurrencyProvider
  require "date"
  require "yaml"
  require 'net/http'
  require 'open-uri'
  require "nokogiri"

  CONFIG = 'config.yml'
  attr_accessor :config, :currency

  def initialize(in_url = nil)
    @config = YAML.load(File.open(CONFIG))
    @dir_url = URI(@config["urls"]["dir"])
  end


  def get_fix(curr = @currency, date = DateTime.now)
    begin
      source_uri = @config["urls"]["main"] + get_xml_filename(date)
      doc = Nokogiri::XML(open(source_uri))
      kurs = doc.xpath("//pozycja[kod_waluty='#{curr.symbol}']/kurs_sredni").text
      raise 'Fix not found' if kurs == ''
      return kurs.gsub!(/,/) { '.' }.to_f
    rescue Exception => e
      puts e.message
      puts e.backtrace
    end
  end

  private

  def get_xml_filename(date, table = 'a')
    date_part = date.strftime("%y%m%d")
    pattern = Regexp.new "#{table}\\d{3}z#{date_part}"
    # try to get xml_filename
    begin
      data = Net::HTTP.get(@dir_url)
      match = pattern.match(data)
      raise "Ups... file not found. Try again later." if match.nil?
      return "#{match}.xml"
    rescue Exception => e
      puts e.message
    end
  end


end
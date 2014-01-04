class Currency
  attr_accessor :symbol, :fix, :quantity

  def initialize(symbol = 'USD')
    @symbol = symbol
    @fix = 0.0
    @quantity = 1
  end

  def to_s
    "#{@symbol}: #{fix.to_s}"
  end

  def sum
    @quantity * @fix
  end

end
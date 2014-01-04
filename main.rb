require_relative "currency_provider.rb"
require_relative "currency.rb"

cur = Currency.new('GBP')
cp = CurrencyProvider.new

cur.fix = cp.get_fix(cur)
p cur.sum
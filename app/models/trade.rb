class Trade < ApplicationRecord
  belongs_to :transaction_type

  before_create ->(trade) {
    trade.notional_amount = (trade.par_traded.to_f * trade_price) / 100
  }
end

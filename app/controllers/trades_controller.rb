class TradesController < ApplicationController
  def index
    @transaction_types = TransactionType.mapped_transaction_types

    trades_filter = Trade.where(params[:filters])
    @trades = trades_filter.page(params[:page]).per(25)
    @statistics = {}

    @statistics[:total_rows] = Hash[@transaction_types.map do |k, v|
      [k.to_sym, trades_filter.where(transaction_type_id: v).count]
    end]

    @statistics[:sum] = Hash[@transaction_types.map do |k, v|
      [k.to_sym, trades_filter.where(transaction_type_id: v).group(:transaction_type_id).sum(:notional_amount)]
    end]

    @statistics[:notional_amount_sum] = trades_filter.sum(:notional_amount)

    @statistics[:max_trade_date] = trades_filter.maximum(:trade_date)
    @statistics[:min_trade_date] = trades_filter.minimum(:trade_date)

    @statistics[:trade_price_avg] = trades_filter.average(:trade_price)
    @statistics[:par_traded_avg] = trades_filter.average(:par_traded)
  end
end

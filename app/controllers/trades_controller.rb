class TradesController < ApplicationController
  def index
    @transaction_types = TransactionType.mapped_transaction_types

    trades_filter = Trade.where(params[:filters])
    @trades = trades_filter.page(params[:page]).per(25)
    @statistics = {}
    @statistics[:total_rows] = Hash[@transaction_types.map do |k, v|
      [k.to_sym, trades_filter.where(transaction_type_id: v).count]
    end]
  end
end

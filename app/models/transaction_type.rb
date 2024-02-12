class TransactionType < ApplicationRecord

  def self.mapped_transaction_types
    TransactionType.pluck(:code, :id).to_h
  end

end

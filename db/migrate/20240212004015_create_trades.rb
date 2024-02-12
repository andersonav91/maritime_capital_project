class CreateTrades < ActiveRecord::Migration[7.1]
  def change
    create_table :trades do |t|
      t.date :trade_date
      t.datetime :trade_date_time
      t.string :row_id
      t.string :security_id
      t.string :security_name
      t.float :coupon_rate
      t.date :maturity_date
      t.references :transaction_type, null: false, foreign_key: true
      t.float :trade_price
      t.integer :trade_yield
      t.integer :par_traded
      t.float :notional_amount

      t.timestamps
    end
  end
end

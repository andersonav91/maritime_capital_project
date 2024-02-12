class CreateTransactionTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :transaction_types do |t|
      t.string :code, limit: 2
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end

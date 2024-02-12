require 'csv'

# deleting all data
Trade.delete_all
TransactionType.delete_all

# creating the transaction_types
transaction_types_data = [
  { code: "P", name: "Purchase From Customer", description: "Transaction where a broker has purchased the security from their customer" },
  { code: "S", name: "Sell to Customer", description: "Transaction where a dealer has sold the security to their customer." },
  { code: "D", name: "Dealer to Dealer", description: "Transaction where one dealer traded the security to another dealer." },
  { code: "I", name: "Invalid Transaction Type", description: "Possible bad formed row, an extra comma in the security_name for example." }
]
transaction_types_data.each do |data|
  TransactionType.create!(data)
end

mapped_transaction_types = TransactionType.mapped_transaction_types

def prepare_batch_data(batch, mapped_transaction_types)
  batch.map do |row|
    {
      trade_date: row['trade_date'].to_date,
      trade_date_time: (row['trade_datetime'].to_datetime rescue ''),
      row_id: row['row_id'],
      security_id: row['security_id'],
      security_name: row['security_name'],
      coupon_rate: row['coupon_rate'],
      maturity_date: (row['maturity_date'].to_date rescue ''),
      transaction_type_id: mapped_transaction_types[row['transaction_type']] || mapped_transaction_types["I"],
      trade_price: row['trade_price'],
      trade_yield: row['trade_yield'],
      par_traded: row['par_traded'],
      notional_amount: row['notional_amount']
    }
  end
end

def insert_batch_with_retry(batch_data)
  max_retries = 3
  retries = 0
  begin
    Trade.insert_all(batch_data)
  rescue => e
    retries += 1
    if retries <= max_retries
      puts "Error: #{e.message}. Retrying (#{retries}/#{max_retries})..."
      sleep(2 ** retries)
      retry
    else
      puts "Was no possible to insert the batch: #{e.message}."
    end
  end
end

csv_file = Rails.root.join('db', 'data', 'data.csv')
csv_data = CSV.read(csv_file, headers: true)

batch_data = []

csv_data.each_with_index do |row, index|
  batch_data << row
  if batch_data.size == 20 || index == csv_data.size - 1
    start_index = index - batch_data.size + 1
    end_index = index
    puts "Processing batch #{start_index} - #{end_index} (#{batch_data.size} records)"

    batch_data = prepare_batch_data(batch_data, mapped_transaction_types)
    insert_batch_with_retry(batch_data)

    batch_data = []  # Clear batch_data for next batch
  end
end

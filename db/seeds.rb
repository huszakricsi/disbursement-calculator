require 'csv'

Merchant.destroy_all
Shopper.destroy_all

merchants = []
CSV.foreach('db/dataset/merchants.csv') do |row|
  merchants.push(id: row[0], name: row[1], email: row[2], cif: row[3])
end

shoppers = []
CSV.foreach('db/dataset/shoppers.csv') do |row|
  shoppers.push(id: row[0], name: row[1], email: row[2], nif: row[3])
end

orders = []
CSV.foreach('db/dataset/orders.csv') do |row|
  orders.push(
               id: row[0],
               merchant_id: row[1],
               shopper_id: row[2],
               amount: row[3],
               created_at: row[4],
               completed_at: row[5]
            )
end

Merchant.create(merchants)
Shopper.create(shoppers)
Order.create(orders)

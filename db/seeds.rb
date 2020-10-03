OrderItem.destroy_all
ShipmentItem.destroy_all
Item.destroy_all
Order.destroy_all
Shipment.destroy_all
User.destroy_all

# USERS
admin = User.create!(
  name: 'The Admin', 
  email: 'admin@example.com', 
  password: '1234',
  address: '1560 Colfax Ave.',
  city: 'Denver',
  state: 'CO',
  zip: '80202',
  role: 2
)

user = User.create!(
  name: 'Zach Holcomb',
  email: 'zach@example.com',
  password: '1234',
  address: '594 Fairfax Ave.',
  city: 'Denver',
  state: 'CO',
  zip: '80218',
  role: 1
)

guest = User.create!(
  name: 'Michael Jordan',
  email: 'mj@example.com',
  password: '1234',
  address: '180 Apple St.',
  city: 'Denver',
  state: 'CO',
  zip: '80505',
  role: 0
)

# ITEMS
loaf = Item.create!(name: 'Sourdough Batard', price: 750)
loaf.image.attach(io: File.open('/Users/zachholcomb/projects/good_bread/good_bread_be/storage/bread.jpg'), filename: 'bread.jpg')

olive_loaf = Item.create!(name: 'Olive and Polenta Loaf', price: 80)
loaf.image.attach(io: File.open('/Users/zachholcomb/projects/good_bread/good_bread_be/storage/bread.jpg'), filename: 'bread.jpg')

plain_croissant = Item.create!(name: 'Plain Croissant', price: 40)
loaf.image.attach(io: File.open('/Users/zachholcomb/projects/good_bread/good_bread_be/storage/croissant.jpg'), filename: 'croissant.jpg')

chocolate_croissant = Item.create!(name: 'Chocolate Croissant', price: 45)
loaf.image.attach(io: File.open('/Users/zachholcomb/projects/good_bread/good_bread_be/storage/chocolate_croissant.jpg'), filename: 'chocolate_croissant.jpg')

danish = Item.create!(name: 'Danish', price: 45)
loaf.image.attach(io: File.open('/Users/zachholcomb/projects/good_bread/good_bread_be/storage/danish.jpg'), filename: 'danish.jpg')

ham_cheese_croissant = Item.create!(name: 'Ham and Cheese Croissant', price: 4)
loaf.image.attach(io: File.open('/Users/zachholcomb/projects/good_bread/good_bread_be/storage/ham_and_cheese.jpg'), filename: 'ham_and_cheese.jpg')

bagel = Item.create(name: 'Bagel', price: 150)
loaf.image.attach(io: File.open('/Users/zachholcomb/projects/good_bread/good_bread_be/storage/bagel.jpeg'), filename: 'bagel.jpeg')

donut = Item.create(name: 'Donut', price: 400)
loaf.image.attach(io: File.open('/Users/zachholcomb/projects/good_bread/good_bread_be/storage/donut.jpeg'), filename: 'donut.jpeg')


# SUBSCRIPTIONS
user_subscription = Subscription.create!(user: user, delivery_day: 'Thursday', subscription_type: 0)

# SHIPMENTS
shipment_1 = Shipment.create!(subscription: user_subscription, delivery_date: '9/1/2020', status: 2)
shipment_2 = Shipment.create!(subscription: user_subscription, delivery_date: '9/8/2020', status: 2)
shipment_3 = Shipment.create!(subscription: user_subscription, delivery_date: '9/15/2020', status: 2)
shipment_4 = Shipment.create!(subscription: user_subscription, delivery_date: '9/22/2020', status: 2)
shipment_4 = Shipment.create!(subscription: user_subscription, delivery_date: '9/29/2020', status: 1)
shipment_5 = Shipment.create!(subscription: user_subscription, delivery_date: '10/5/2020', status: 0)


# SHIPMENT_ITEMS
shipments = [shipment_1, shipment_2, shipment_3, shipment_4, shipment_5]
items = [loaf, olive_loaf]

shipments.each do |shipment|
  items.each do |item|
    ShipmentItem.create!(shipment: shipment, item: item)
  end
end

# ORDERS
order_1 = Order.create!(user: user, status: 2, delivery_date: '9/7/2020')
order_2 = Order.create!(user: user, status: 1, delivery_date: '9/10/2020')
order_3 = Order.create!(user: user, status: 0, delivery_date: '9/15/2020')
order_4 = Order.create!(user: guest, status: 1, delivery_date: '9/22/2020')

# ODER_ITEMS
orders = [order_1, order_2, order_3]

orders.each do |order|
  12.times do
    OrderItem.create!(order: order, item: bagel)
  end
end

6.times do 
  OrderItem.create!(order: order_4, item: donut)
end
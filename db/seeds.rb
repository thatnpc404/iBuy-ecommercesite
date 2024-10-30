# db/seeds.rb

categories = [ 'Electronics', 'Clothing', 'Fragrances', 'Toys', 'Cosmetics']

categories.each do |category_name|
  Category.find_or_create_by(name: category_name)
end

puts "Seeded #{categories.length} categories."

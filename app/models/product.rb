class Product < ActiveRecord::Base
  self.table_name = 'product'
  has_many :case
end

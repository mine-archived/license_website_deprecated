class Release < ActiveRecord::Base
  self.table_name = 'release_tbl'
  has_many :products
end
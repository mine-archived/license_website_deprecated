class VCase < ActiveRecord::Base
  self.table_name = "v_product_repo"
end

class Case < ActiveRecord::Base
  self.table_name = "product_repo"
end

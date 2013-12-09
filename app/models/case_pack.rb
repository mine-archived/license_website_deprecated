class CasePack < ActiveRecord::Base
  self.table_name = "product_repo_pack"
  belongs_to :case, foreign_key: 'product_repo_id'
  belongs_to :pack, foreign_key: 'pack_id'
end
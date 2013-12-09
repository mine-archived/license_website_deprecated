class Case < ActiveRecord::Base
  self.table_name = "product_repo"
  belongs_to :release, foreign_key: 'release_id'
  belongs_to :product, foreign_key: 'product_id'
  belongs_to :repo, foreign_key: 'repo_id'
end
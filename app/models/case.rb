class Case < ActiveRecord::Base
  self.table_name = "product_repo"
  belongs_to :release, foreign_key: 'release_id'
  belongs_to :product, foreign_key: 'product_id'
  belongs_to :repo, foreign_key: 'repo_id'

  def self.get_packs_by_case_id(case_id)
    sql = "select pack.*
           from product_repo_pack
	   join pack on product_repo_pack.pack_id = pack.id
	   where product_repo_pack.product_repo_id = #{case_id}"
    records_array = ActiveRecord::Base.connection.execute(sql)
  end
end


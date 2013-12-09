class Product < ActiveRecord::Base
  self.table_name = 'product'
  has_many :case

  def self.related_repos(product_id, release_id)
    sql = "select product_repo.id, repo.name
           from product_repo
           join product on product_repo.product_id = product.id
           join repo on product_repo.repo_id = repo.id
           join release_tbl on product_repo.release_id = release_tbl.id
           where product.id = #{product_id}
           and release_tbl.id = #{release_id}"

    records_array = ActiveRecord::Base.connection.execute(sql)
  end


end

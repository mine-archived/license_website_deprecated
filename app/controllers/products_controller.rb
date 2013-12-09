require 'writeexcel'

class ProductsController < ApplicationController

  def index
    @release_id = params[:release_id]
    @cases = Case.joins(:release, :product, :repo).order(:product_id)
    if @release_id
      @cases = @cases.where(release_id: @release_id)
    end

    @cases = @cases.to_a.uniq {|item|
      item.product.id
    }
  end

  def self.complete_ratio(product_id, release_id)
    # FIXME: SQL injection
    sql = "select product_complete_ratio(#{product_id}, #{release_id})"
    ratio = ActiveRecord::Base.connection.execute(sql)
    ratio[0]['product_complete_ratio']
  end

  def show
    release_id = params[:release_id]
    product_id = params[:id]
    related_repos = Product.related_repos(product_id, release_id)
    # TODO: @Micfan
    related_repos_packs = {}
    related_repos.each {|item|
      packs = Case.get_packs_by_case_id(item['id'])
      related_repos_packs[item['name']] = packs
    }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: related_repos_packs}
      format.xls {
        product_name = Product.find_by(id: product_id).name
        release_version = Release.find_by(id: release_id).version
        excel_filepath = ExcelHelper::ExcelExport.new.export_excel_by_product(product_name, release_version, related_repos_packs)
        send_file(excel_filepath)
      }
    end
  end

  # def export_by_product_id
  #   product_id = params[:id].to_i
  #   repo_list = ExcelHelper::ExcelExport.new.get_repo_list_of_product(product_id, @release_id)
  #   excel_workbook_path = ExcelHelper::ExcelExport.new.export_excel_by_product(product_id, @release_id)
  #
  #   # 'Content-Disposition: attachment;
  #   send_file(excel_workbook_path, :type => 'application/vnd.ms-excel')
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.xml  { render xml: @repos}
  #     format.json { render json: @repos}
  #     format.xlsx { render xlsx: @repos}
  #   end
  # end

end
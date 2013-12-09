require 'writeexcel'

class ProductsController < ApplicationController

  def initialize
    @release_id = 1
  end

  def index
    release_id = params[:release_id]
    @cases = Case.joins(:release, :product, :repo).order(:product_id)
    if release_id
      @cases = @cases.where(release_id: release_id)
    end

    @cases = @cases.to_a.uniq {|item|
      item.product.id
    }
  end

  def export_excel_by_product
    product_id = params[:id].to_i
    repo_list = ExcelHelper::ExcelExport.new.get_repo_list_of_product(product_id, @release_id)
    excel_workbook_path = ExcelHelper::ExcelExport.new.export_excel_by_product(product_id, @release_id)

    # 'Content-Disposition: attachment;
    send_file(excel_workbook_path, :type => 'application/vnd.ms-excel')
  end

  def export_json_by_product
    product_id = params[:id].to_i
    repo_list = ExcelHelper::ExcelExport.new.get_repo_list_of_product(product_id, @release_id)

    render json: {error_code: 0, repo_list: repo_list}

  end

end
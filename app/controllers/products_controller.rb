require 'writeexcel'

class ProductsController < ApplicationController

  def initialize
    @release_id = 1
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
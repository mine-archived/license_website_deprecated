require 'writeexcel'

class ProductController < ApplicationController

  def initialize
    @release_id = 1
  end

  def export_excel_by_product
    product_id = params[:id].to_i
    repo_list = ExcelHelper::ExcelExport.new.get_repo_list_of_product(product_id, @release_id)

    excel_workbook = ExcelHelper::ExcelExport.new.export_excel_by_product(product_id, @release_id)
    render json: {error_code: 0, repo_list: repo_list}
    # render

  end

  def export_json_by_product
    product_id = params[:id].to_i
    repo_list = ExcelHelper::ExcelExport.new.get_repo_list_of_product(product_id, @release_id)

    render json: {error_code: 0, repo_list: repo_list}

  end

end
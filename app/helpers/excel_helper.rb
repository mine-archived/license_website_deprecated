
module ExcelHelper
  class ExcelExport
    def initialize
      #TODO
    end

    # TODO: move into product_controller.rb
    def get_repo_list_of_product(product_id = 20, release_id = 1)
      sql = "select product_repo.id, repo.name
           from product_repo
           join product on product_repo.product_id = product.id
           join repo on product_repo.repo_id = repo.id
           join release_tbl on product_repo.release_id = release_tbl.id
           where product.id = '#{product_id}'
           and release_tbl.id = '#{release_id}'"

      records_array = ActiveRecord::Base.connection.execute(sql)
      return records_array
    end

    # TODO: move into product_helper.rb
    def api_get_template_result_by_product_repo_id(id)
      sql = "select pack.name, pack.version, pack.unclear_license, pack.license, pack.license_text, pack.source_url
                from product_repo_pack
                join pack on product_repo_pack.pack_id = pack.id
                where product_repo_pack.product_repo_id = #{id}"
      records_array = ActiveRecord::Base.connection.execute(sql)
      if records_array.ntuples > 0
        return records_array
      end
      records_array
    end

    # TODO: set a temp dir /tmp/auto/excle/xxx.xlsx
    def export_excel_by_product(product_id, release_id)
      product = Product.find_by(id: product_id)
      workbook_name = product.name + '-1.5-scotzilla-script.xls'

      repo_list = get_repo_list_of_product(product_id, release_id)

      if repo_list == nil
        return nil
      end

      # Create a new workbook and add a worksheet
      workbook  = WriteExcel.new(workbook_name)

      insert_validation_worksheet(workbook)
      #  list {id->product_repo.id, name->repo.name}

      insert_repolist_worksheet(workbook, repo_list)

      workbook.close

      # TODO: return a file object
      return workbook

    end

    def insert_repolist_worksheet(workbook, repolist)

      # Create a format for the column headings
      header = workbook.add_format
      header.set_bold
      header.set_size(12)
      header.set_color('black')

      num = 0
      while num < repolist.ntuples() do
        # get pack list from db
        packlist = api_get_template_result_by_product_repo_id(repolist[num]['id'])

        unless packlist == nil
          worksheet = nil
          worksheet = workbook.add_worksheet(repolist[num]['name'])
          # Set the column width for columns 1 ~ 9
          worksheet.set_column(0, 4, 20)
          worksheet.set_column(5, 5, 40)
          worksheet.set_column(6, 6, 15)
          worksheet.set_column(7, 7, 35)
          worksheet.set_column(8, 8, 15)

          # TODO: @Micfan, validation excle

          set_repo_worksheet(worksheet, packlist, header)
        end
        num = num + 1
        next
      end

    end

    def set_repo_worksheet(worksheet, packlist, header)

      j = 0
      # Write header data
      worksheet.write(j, 0, 'Name', header)
      worksheet.write(j, 1, 'Version', header)
      worksheet.write(j, 2, 'Description', header)
      worksheet.write(j, 3, 'License', header)
      worksheet.write(j, 4, 'License Text', header)
      worksheet.write(j, 5, 'URL', header)
      worksheet.write(j, 6, 'Modified', header)
      worksheet.write(j, 7, 'Interaction', header)
      worksheet.write(j, 8, 'OSS Project', header)

      # Write pack info list
      while j < packlist.ntuples() do
        worksheet.write(j+1, 0, packlist[j]['name'])
        worksheet.write(j+1, 1, packlist[j]['version'])
        worksheet.write(j+1, 2, packlist[j]['unclear_license'])
        worksheet.write(j+1, 3, packlist[j]['license'])
        #worksheet.write(j+1, 4, packlist[j]['license_text'])
        worksheet.write(j+1, 5, packlist[j]['source_url'])
        worksheet.write(j+1, 6, 'No')
        worksheet.write(j+1, 7, 'Distributed - Calling Existing Classes')
        worksheet.write(j+1, 8, '')
        j = j + 1
        next
      end

    end

    def insert_validation_worksheet(workbook)

      worksheet = workbook.add_worksheet('Validation')
      worksheet.set_column(0, 2, 30)

      # define the header format
      header = workbook.add_format
      header.set_bold
      header.set_size(10)
      header.set_color('black')

      # Write Data
      #header
      worksheet.write(0, 0, 'InteractionTypes', header)
      worksheet.write(0, 1, 'ModificationOptions', header)
      worksheet.write(0, 2, 'LicenseChoices', header)

      #InteractionTypes
      worksheet.write(1, 0, 'Distributed - Calling Existing Classes')
      worksheet.write(2, 0, 'Distributed - Deriving New Classes')
      worksheet.write(3, 0, 'Distributed - Dynamic Link w/ OSS')
      worksheet.write(4, 0, 'Distributed - Dynamic Link w/ TP')
      worksheet.write(5, 0, 'Distributed - Dynamic Link w/ VMW')
      worksheet.write(6, 0, 'Distributed - No Linking')
      worksheet.write(7, 0, 'Distributed - OS Layer')
      worksheet.write(8, 0, 'Distributed - Other')
      worksheet.write(9, 0, 'Distributed - Static Link w/ OSS')
      worksheet.write(10, 0, 'Distributed - Static Link w/ TP')
      worksheet.write(11, 0, 'Distributed - Static Link w/ VMW')
      worksheet.write(12, 0, 'Internal Use Only')

      # Modification Options
      worksheet.write(1, 1, 'No')
      worksheet.write(2, 1, 'Yes')

      # License Choices
      licenses = StdLicense.all
      num = 0
      while num < licenses.size do
        worksheet.write(num+1, 2, licenses[num].name)
        num = num + 1
        # TODO: remove
        next
      end

    end

  end
end



module ExcelHelper
  class ExcelExport
    def initialize
      @temp_dir_excel = APP_CONFIG['temp_dir_excel']
    end

    def export_excel_by_product(product_name, release_version, related_repos_packs)
      excel_workbook_path = "#{@temp_dir_excel}/#{product_name}-#{release_version}-script.xls"

      if related_repos_packs.length == 0
        return nil
      end

      # Create a new workbook and add a worksheet
      workbook  = WriteExcel.new(excel_workbook_path)
      insert_validation_worksheet(workbook)
      related_repos_packs.each {|repo_name, packs|
        insert_worksheet_by_repo_name(workbook, repo_name, packs)
      }

      workbook.close

      return excel_workbook_path
    end

    def insert_worksheet_by_repo_name(workbook, repo_name, packs)
      # Create a format for the column headings
      header = workbook.add_format
      header.set_bold
      header.set_size(12)
      header.set_color('black')

      worksheet = workbook.add_worksheet(repo_name)
      # Set the column width for columns 1 ~ 9
      worksheet.set_column(0, 4, 20)
      worksheet.set_column(5, 5, 40)
      worksheet.set_column(6, 6, 15)
      worksheet.set_column(7, 7, 35)
      worksheet.set_column(8, 8, 15)

      set_repo_worksheet(worksheet, packs, header)

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


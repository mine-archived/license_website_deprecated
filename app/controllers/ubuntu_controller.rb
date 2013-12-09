require 'json'

class UbuntuController < ApplicationController

  def index


  end

  def insert_packs
    packs = params[:all_packs]
    @repo  = params[:repo]
    # language = params[:language]
    @pack_list =[]
    @display_list = []
    pattern = /(?<status>[^\s]+)\s+(?<name>[^\s]+)\s+(?<version>[^\s]+)\s+(?<arch>[^\s]+)\s+(?<description>.*)/
    packs.split("\n").each{|row|
      if /^(Desired|\||\+)/.match(row)
        next
        # TODO: ignore
        # Desired=Unknown/Install/Remove/Purge/Hold
        # | Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
        # |/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
        # ||/ Name                  Version            Architecture Description
      end
      matchdata = pattern.match(row)
      if matchdata
        item = {
            :name    => matchdata[:name],
            :version => matchdata[:version]
        }
        @pack_list << item
      end
    }
    @pack_list.each do |element|
      insert = Pack.find_by(name: element[:name], version: element[:version],
                            lang:params[:language])
      if insert == nil
        insert = Pack.new
        insert.name = element[:name]
        insert.version = element[:version]
        insert.lang = params[:language]
        begin
          insert.save
          @display_list << ['true',insert.id, insert.name, insert.version,
                            insert.lang, insert.status]
        rescue Exception => e
          p "error"
          @display_list << ['error', e ]
        end

      else
        @display_list << [ 'false',insert.id, insert.name, insert.version,
                           insert.lang, insert.status]
      end

    end
    # render text: repo
  end

  # Preview
  def create
    @packs = []
    @repo = 'ubuntu-15.04'
    @error_messages = []
    @button = "submit"

    distribution = 'Ubuntu'
    distro_series = 'Trusty'
    @langguage = [distribution, distro_series].join('-')

    file = params[:mytest][:myfile]
    pattern = /(?<status>[^\s]+)\s+(?<name>[^\s]+)\s+(?<version>[^\s]+)\s+(?<arch>[^\s]+)\s+(?<description>.*)/
    @contents = file.read
    @contents.split("\n").each_with_index{|row, i|
      if /^(Desired|\||\+)/.match(row)
        next
        # TODO: ignore
        # Desired=Unknown/Install/Remove/Purge/Hold
        # | Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
        # |/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
        # ||/ Name                  Version            Architecture Description
      end

      matchdata = pattern.match(row)
      if matchdata
        item = {
            :name    => matchdata[:name],
            :version => matchdata[:version],
            :arch    => matchdata[:arch],
            :description => matchdata[:description]
        }
        # @packs << item.to_json  <!--<td><%= JSON.parse(row)['repo'] %></td>-->
        @packs << item
      else
        # TODO:
        # @error_messages.push("line: #{error_line_no}, #{row} is invalid data, ")
        @packs.push("line: #{i+1}, #{row} is invalid data, ")
        @button = "hidden"
      end
    }

    is_preview = params[:is_preview] == 'true'
    if is_preview
    else
      render action: 'index' #, :packs => @packs
    end
  end

  def new
    p "update 2222222222221111oooooppppp"
    render json: {"OK": "#{@packs}"}
  end

end
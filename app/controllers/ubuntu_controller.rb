require 'csv'
class UbuntuController < ApplicationController

  def index
  end

  def create
    # original_filename, content_type, read, write, length
    file = params[:mytest][:myfile]

    content_type = file.content_type
    original_filename = file.original_filename
    content = file.read
    p content
    # @packs = CSV.parse(content)
    @packs = Array.new
    pack = content.split("\n")
    pack.each{ |row|
      hs = Hash.new
      hs['name']    = row.split(',')[0];
      hs['version'] = row.split(',')[1];
      hs['repo']    = 'ubuntu'
      @packs << hs
    }
    is_preview = params[:is_preview] == 'true'
    if is_preview
    else
      # TODO: inert into db
      render action: 'index' #, :packs => @packs
    end

  end

end
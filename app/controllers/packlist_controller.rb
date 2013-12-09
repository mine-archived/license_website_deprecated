class PacklistController < ApplicationController
  def index
    if params.size > 2
      @case_packs = CasePack.joins(:pack, :case).order('pack.name')

      @release_id = params[:release_id]
      if @release_id and '' != @release_id
        @case_packs = @case_packs.where(product_repo: {release_id: @release_id})
      end

      @repo_id = params[:repo_id]
      if @repo_id and '' != @repo_id
        @case_packs = @case_packs.where(product_repo: {repo_id: @repo_id})
      end

      @status = params[:status]
      if @status and '' != @status
        @case_packs = @case_packs.where(pack: {status: @status})
      end

      @pack_name = params[:pack_name]
      if @pack_name and '' != @pack_name
        @case_packs = @case_packs.where(pack: {name: @pack_name})
      end

      @lang = params[:lang]
      if @lang and '' != @lang
        @case_packs = @case_packs.where(pack: {lang: @lang})
      end

      @create_at = params[:create_at]
      if @create_at and '' != @create_at
        @case_packs = @case_packs.where(pack: {create_at: @create_at})
      end
    else
      @case_packs = []
    end
  end

  def show
    pack_id = params[:id]
    @pack = Pack.find_by(id: pack_id)
  end

  def edit
    pack_id = params[:id]
    @pack = Pack.find_by(id: pack_id)
  end

  def update
    pack_id = params[:id]
    @pack = Pack.find_by(id: pack_id)
    if @pack
      @pack.status = params[:status]
      @pack.homepage = params[:homepage]
      @pack.source_url = params[:source_url]
      @pack.license_url = params[:license_url]
      @pack.license = params[:license]
      @pack.license_text = params[:license_text]
      @pack.cmt = params[:cmt]
      @pack.save
      # TODO: message user success
    else
      # TODO: message user failed
    end
  end
end
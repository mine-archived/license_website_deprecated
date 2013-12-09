class PacklistController < ApplicationController
  def index
    @packs = Pack.all.order('name','version')
  end

  def show

    @packs = CasePack.joins(:pack, :case).order('pack.name')

    @release_id = params[:release_id]
    if @release_id and '' != @release_id
      @packs = @packs.where(product_repo: {release_id: @release_id})
    end

    @repo_id = params[:repo_id]
    if @repo_id and '' != @repo_id
      @packs = @packs.where(product_repo: {repo_id: @repo_id})
    end

    @status = params[:status]
    if @status and '' != @status
      @packs = @packs.where(pack: {status: @status})
    end

    @pack_name = params[:pack_name]
    if @pack_name and '' != @pack_name
      @packs = @packs.where(pack: {name: @pack_name})
    end

    @lang = params[:lang]
    if @lang and '' != @lang
      @packs = @packs.where(pack: {lang: @lang})
    end

    @create_at = params[:create_at]
    if @create_at and '' != @create_at
      @packs = @packs.where(pack: {create_at: @create_at})
    end

  end
end
class PacksController < ApplicationController
  def index
    # @packs = Case.joins(:release, :product, :repo).order(:repo_id)

    repo_id = params[:repo_id]
    if repo_id
      @repo = Repo.find_by(id: repo_id)
    else
      @repo = nil
    end

    @packs = CasePack.joins(:pack, :case).where(product_repo: {repo_id: repo_id}).order('pack.name')

    release_id = params[:release_id]
    if release_id
      @packs = @packs.where(product_repo: {release_id: release_id})
    end

    product_id = params[:product_id]
    if product_id
      @packs = @packs.where(product_repo: {product_id: product_id})
    else

      @packs = @packs
    end

    # if params[:release_id]
    #   @packs = @packs.where(release_id: params[:release_id])
    # end
    # if repo_id
    #   @packs = @packs.where("product_repo.repo_id = #{repo_id}")
    # end
  end


end
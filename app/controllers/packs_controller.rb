class PacksController < ApplicationController
  def index
    # @packs = Case.joins(:release, :product, :repo).order(:repo_id)
    release_id = params[:release_id]
    repo_id = params[:repo_id]
    @repo = Repo.find_by(id: repo_id)
    # @packs = CasePack.includes(:pack).includes(case: [:repo, :product])
    #           .where(case: {repo_id: repo_id})

    @packs = CasePack.joins(:pack, :case).where(product_repo: {repo_id: repo_id})

    p @packs

    # if params[:release_id]
    #   @packs = @packs.where(release_id: params[:release_id])
    # end
    # if repo_id
    #   @packs = @packs.where("product_repo.repo_id = #{repo_id}")
    # end
  end


end
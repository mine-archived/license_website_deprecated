require "bunny"

class ReposController < ApplicationController

  def index
    @release_id = params[:release_id]
    @cases = Case.includes(:release, :product, :repo).order(:repo_id)
    if @release_id
      @cases = @cases.where(release_id: @release_id)
    end

    product_id = params[:product_id]
    if product_id
      @cases = @cases.where(product_id: product_id)
    end

    @cases = @cases.to_a.uniq {|item|
      item.repo.id
    }
    @cases.each {|c|
      # If Not found
      if c.repo.priv == -1
        next
      end
      source_url = c.repo.source_url
      cache_key = "linguist/#{source_url}"
      languages = Rails.cache.fetch(cache_key)
      # TODO: @Cissy, fetch languages from github if it's a github url
      # if languages == nil
      #   begin
      #   local_path = ReposHelper.clone_repo(source_url)
      #   linguist = LinguistHelper::Language.new(local_path)
      #   language, languages = linguist.get_languages_percent
      #   Rails.cache.fetch(cache_key, expires_in: 24.hours) do
      #     languages
      #   end
      #   rescue Exception => e
      #     # TODO:
      #     p e
      #   end
      # end
    }


    # Rails.cache.fetch("#{cache_key}/competing_price", expires_in: 12.hours) do
    #   Competitor::API.find_price(id)
    # end

    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.xml  { render xml: @repos}
    #   format.json { render json: @repos}
    # end
    # render(@cases, 'index.html.erb')
  end

  def new
    @repo = Repo.new
  end

  def self.complete_ratio(repo_id, release_id)
    sql = "select repo_complete_ratio(#{release_id}, #{repo_id})"
    p sql
    ratio = ActiveRecord::Base.connection.execute(sql)
    ratio[0]['repo_complete_ratio']
  end


  # Enter queue
  def _enqueue_mq(case_item, check_status=true)
    conn = Bunny.new("amqp://guest:guest@localhost:5672")
    conn.start
    ch = conn.create_channel
    q = ch.queue('license_auto.repo', :auto_release => true, :durable => true)
    x = ch.default_exchange

    x.publish(case_item, :routing_key => q.name)
    ch.close

    # TODO:
    if check_status
      # c = Case.find_by(id: case_id)
    end
  end

  def self.make_repo_local_path(source_url)
    repo = source_url.gsub(/(http[s]?:\/\/|git@)/, '')
    path = "#{APP_CONFIG['temp_dir']}/#{repo}"
  end

  def parse_dependency
    repo_id = params[:repoId].to_i
    release_id = params[:releaseId].to_i
    c = Repo.find_by(id: repo_id)
    message = {
      :repo_id => repo_id,
      :release_id => release_id
    }
    _enqueue_mq(message.to_json)
    # Publisher.publish('cases', {:case_id => case_id})
    render json: {error_code: 0, repo_id: repo_id}
  end

  def parse_all_repo
    release_id = params[:releaseId].to_i

  end

  def enqueue_all_repo
    repos = Repo.all
    # TODO: @Micfan, config
    conn = Bunny.new("amqp://guest:guest@localhost:5672")
    conn.start
    ch = conn.create_channel
    q = ch.queue('license_auto.repo', :auto_release => true, :durable => true)
    x = ch.default_exchange
    count = 0
    repos.each {|r|
      repo_id = r['id']
      x.publish({:repo_id => repo_id}.to_json, :routing_key => q.name)
      count += 1
    }
    ch.close
    render json: {error_code: 0, count: count}
  end

  def enqueue_all_pack
    repos = Pack.where("status < 30")
    # TODO: @Micfan, config
    conn = Bunny.new("amqp://guest:guest@localhost:5672")
    conn.start
    ch = conn.create_channel
    q = ch.queue('license_auto.repo', :auto_release => true, :durable => true)
    x = ch.default_exchange
    count = 0
    repos.each {|r|
      repo_id = r['id']
      x.publish({:repo_id => repo_id}.to_json, :routing_key => q.name)
      count += 1
    }
    ch.close
    render json: {error_code: 0, count: count}
  end


end

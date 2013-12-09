require "bunny"

class ReposController < ApplicationController

  def index
    release_id = params[:release_id]
    @cases = Case.joins(:release, :product, :repo)
    if release_id
      @cases = @cases.where(release_id: release_id)
    end
    puts '-'*80
    @cases.each {|c|
      p c.class
    }
    # Rails.cache.fetch("#{cache_key}/competing_price", expires_in: 12.hours) do
    #   Competitor::API.find_price(id)
    # end

    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.xml  { render xml: @repos}
    #   format.json { render json: @repos}
    # end
  end

  def new
    @repo = Repo.new
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
    c = Repo.find_by(id: repo_id)
    c.update(status: 20)

    _enqueue_mq({:repo_id => repo_id}.to_json)
    # Publisher.publish('cases', {:case_id => case_id})
    render json: {error_code: 0, repo_id: repo_id}
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

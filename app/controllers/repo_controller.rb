require "bunny"

class RepoController < ApplicationController

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
    repos = Pack.where("status < 40")
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

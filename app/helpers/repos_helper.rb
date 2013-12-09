module ReposHelper
  def self.make_path(source_url)
    # todo: If source_url is a git@github.com:xxx/yyy
    source_url = source_url.gsub(/(https:\/\/|http:\/\/|git@)/,'')
    path = "#{APP_CONFIG['temp_dir']}/#{source_url}"
  end

  def self.clone_repo(source_url, reclone=false)
    path = self.make_path(source_url)
    if reclone
      FileUtils::rm_rf(path)
    end

    # begin
    # Git.configure do |config|
    # If you want to use a custom git binary
    # config.binary_path = '/git/bin/path'

    # If you need to use a custom SSH script
    # Config private SSH key on github.com
    #   config.git_ssh = "#{AUTO_ROOT}/git_ssh_wrapper.sh"
    # end
    if Dir.exists?(path)
      if false
        g = Git.open(path, :log => $plog)
        local_branch = g.branches.local[0].full
        g.pull(remote='origin', branch=local_branch)
      end
    else
      local_repo = Git.clone(source_url, path)
      clone_path = local_repo.dir.path
      return clone_path
    end

    return path
    # rescue Git::GitExecuteError => e
    #   $plog.error e
    #   return nil
    # return self.clone_repo(source_url, reclone=true)
    # end
  end
end

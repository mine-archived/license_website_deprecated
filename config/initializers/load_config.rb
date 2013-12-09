APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]

def create_directory(path)
  array_path = path.split('/')
  path = ""
  i = 1
  while i < array_path.length
    path += "/" + array_path[i]
    if !Dir.exist?(path)
      if 0 != Dir.mkdir(path)
        raise("Create path:#{path} failed, plsea check your permission.")
      end
    end
    i += 1
  end

end

create_directory(APP_CONFIG['temp_dir'])
create_directory(APP_CONFIG['temp_dir_excel'])

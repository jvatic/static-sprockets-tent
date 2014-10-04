require 'yajl'
require 'fileutils'

module StaticSprocketsTent
  module Model
    def self.user_path(user_id)
      File.join(db_path, user_id)
    end

    def self.index_path
      @index_path ||= File.join(db_path, 'index.json')
    end

    def self.index
      return @index if @index
      if File.exists?(index_path)
        @index = Yajl::Parser.parse(File.read(index_path), :symbolize_keys => true)
      else
        @index = {}
        persist_index
        @index
      end
    end

    def self.persist_index
      File.open(index_path, 'w') do |f|
        f.write(Yajl::Encoder.encode(index))
      end
    end

    def self.find(user_id)
      path = user_path(user_id)
      if File.exists?(path)
        Yajl::Parser.parse(File.read(path), :symbolize_keys => true)
      end
    end

    def self.lookup(entity)
      if user_id = index[entity.to_sym]
        find(user_id)
      end
    end

    def self.persist(user)
      path = user_path(user.id)
      File.open(path, 'w') do |f|
        f.write(Yajl::Encoder.encode(user.data))
      end

      index[user.entity.to_sym] = user.id
      persist_index
    end

    def self.db_path
      @path ||= ::StaticSprockets.config[:tent_config_db_path] || "/tmp/static-sprockets-tent/db"
    end

    def self.new
      unless File.exists?(db_path)
        FileUtils.mkdir_p(db_path)
      end

      require 'static-sprockets-tent/models/user'
    end
  end
end

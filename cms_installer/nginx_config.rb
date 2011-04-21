module CmsInstaller
  class NginxConfig
    
    attr_reader :instance_path, :gem_path
    
    def self.create(*args)
      NginxConfig.new(*args).run
    end
    
    def initialize(instance_path, gem_path)
      @instance_path, @gem_path = instance_path, gem_path
      @conf_path = File.join(instance_path, 'conf')
    end
    
    def run
      create_dev_config
      puts "**Nginx config file created"
    end
    
    private
    
      # Builds a development config file from a an existing server config file
      def create_dev_config
        default_config_file = File.join(@conf_path, 'main.conf')
        dev_config_file = File.join(@conf_path, 'dev.conf')
        server_instance_path = '/opt/interfacecms/sites/portlandmonthlymag'
        config_contents = IO.read(default_config_file)
        config_contents.gsub!(server_instance_path, instance_path)
        open(dev_config_file, 'w') { |f| f.puts config_contents }
        
        msg = "Insert the following statment in the global Nginx config:\n"
        msg += "include #{dev_config_file}"
        puts msg
      end
  end
end
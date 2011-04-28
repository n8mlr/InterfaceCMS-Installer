# Nate Miller <nate@urbaninfluence.com>
# Used to link the large number of symlinks throughout the application
module CmsInstaller
  class Symlinker
    attr_reader :instance_path, :gem_path, :frontend_path
    
    def self.build_instance_links(*args)
      Symlinker.new(*args).run
    end
    
    def initialize(instance_path, gem_path, frontend_path)
      @instance_path, @gem_path, @frontend_path = instance_path, gem_path, frontend_path
    end
    
    def run
      build_app_links
      build_config_links
      build_public_links
    end
    
    private
      
      # Creates all symlinks for the APP directory
      def build_app_links
        app_links = %w(Rakefile app bin doc jobs lib vendor)
        map_paths( File.join(gem_path),
                   File.join(instance_path, 'app'),
                   app_links)
      end
      
      def build_config_links
        config_links = %w(boot.rb environment.rb environments initializers routes.rb)
        map_paths(File.join(gem_path, 'config'),
                  File.join(instance_path, 'app', 'config'),
                  config_links)
      end
      
      # Creates all symlinks for the PUBLIC directory
      def build_public_links
        gem_symlinks = %w(.htaccess dispatch.cgi dispatch.fcgi dispatch.rb interface)
        frontend_symlinks = %w(img plugins templates)
        
        map_paths(File.join(gem_path, 'public'),
                  File.join(instance_path, 'app', 'public'),
                  gem_symlinks)
        
        frontend_symlink_path = File.join(instance_path, 'app', 'public', 'frontend')
        force_create_symlink(frontend_path, frontend_symlink_path)
        
        map_paths(frontend_path,
                  File.join(instance_path, 'app', 'public'),
                  frontend_symlinks)
      end
      
      # Will copy filenames located in the src directory to the destination
      def map_paths(src, dest, filenames)
        filenames.each do |file_name|
          dest_path = File.join(dest, file_name)
          src_path = File.join(src, file_name)
          force_create_symlink(src_path, dest_path)
        end
      end
      
      # Creates a symlink from src to dest. Will delete any files currently located at dest
      def force_create_symlink(src, dest)
        if File.symlink?(dest) or File.exist?(dest)
          FileUtils.rm(dest) 
        elsif File.directory?(dest)
          FileUtils.rm_rf(dest)
        end
        FileUtils.ln_s(src, dest)
      end
      
  end
end
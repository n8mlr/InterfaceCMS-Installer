# Main application class. Responsible for running the install process
module CmsInstaller
  class Installer
  
    attr_reader :instance_path, :frontend_path, :interfacecms_path
  
    def initialize(gem_path, instance, frontend)
      @interfacecms_path, @instance_path, @frontend_path = gem_path, instance, frontend 
    end
  
    def run
      Symlinker.build_instance_links(instance_path, interfacecms_path, frontend_path)
      NginxConfig.create(instance_path, interfacecms_path)
    end
  end
end
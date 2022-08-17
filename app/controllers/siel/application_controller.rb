module Siel
	class ApplicationController < ActionController::Base
		before_action :get_directories
		layout :getLayout

		private
		def get_directories
			@controllersDirectory = Dir.getwd + '/app/controllers'
			@modelsDirectory = Dir.getwd + '/app/models'
			@viewsDirectory = Dir.getwd + '/app/views'
			
			@templatesDirectory = File.dirname(__FILE__) + '/../../../lib/templates';
			@scaffoldsDirectory = [File.dirname(__FILE__) + '/../../../lib/scaffolds', Dir.getwd + '/lib/scaffolds'];
		end

		def getScaffolds
			
		end
		
		def getModelByName(name)
			Siel::UserModel.new(@modelsDirectory + '/' + name + '.rb')
		end
		
		def parseModelName(name)
			name = name.strip.gsub(/ +/, '_')
		end

		def getLayout	
			return false if request.xhr?
		end
	end
end

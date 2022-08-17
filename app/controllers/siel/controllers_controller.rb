module Siel
	class ControllersController < Siel::ApplicationController

		def index
            @controllers = FileReader.getControllers(@controllersDirectory)
		end
		
		def create
			@models = FileReader.getModels(@modelsDirectory)
		end
		
		def do_create
			controller_name = params[:name].titleize.gsub(/ +/, '') + 'Controller'
			controller_file = params[:name].downcase + '_controller.rb'
			controller_views = @viewsDirectory + '/' + params[:name].downcase
			
			Dir.mkdir(controller_views, 0777) unless File.exist? controller_views
			
			# Controller already exist
			render :json => [-1] and return if File.exist?(@controllersDirectory + '/' + controller_file)
			
			r = 0;
			
			# Create an empty controller
			if params['type'].to_i == 1
				controller_actions = ['index'] # index added by default
				params[:methods].gsub(/, */, ',').split(',').each do |action|
					action = action.strip.downcase
					controller_actions << action
				end
				
				template = ERB.new(File.read(@templatesDirectory + '/controller.rb'))
				File.open(@controllersDirectory + '/' + controller_file, 'w') do |file|
					file.write(template.result(binding))
					file.close()
				end
			else 
				# Create an scaffold
				directory = params[:scaffold].strip
				views_directory = directory + '/views'
				xcontroller_file = directory + '/controller.rb'
				
				render :json => [-4] and return unless File.exist? xcontroller_file

				all_var = params[:name].strip.downcase
				
				
				#model = name.join('_').downcase
				model_name = params[:model]
				

				model_file = params[:model].split /(?!(^|[a-z]|$))/
				model_file = model_file.join('_')

				model_var = model_file.downcase

				object = getModelByName(model_file).get_const.new				
				# create the controller file
				controller_template = ERB.new(File.read(xcontroller_file))
				File.open(@controllersDirectory + '/' + controller_file, 'w') do |file|
					file.write(controller_template.result(binding))
					file.close()
				end
				
				# create the views
				views = Dir.glob(views_directory + '/*.html') + Dir.glob(views_directory + '/*.rhtml') + Dir.glob(views_directory + '/*.erb')
				views.each do |view_file|
					view_name = File.basename(view_file)
					view_template = ERB.new(File.read(view_file))
					File.open(controller_views + '/' + view_name, 'w') do |file|
						file.write(view_template.result(binding))
						file.close()
					end
				end
			
			end
			
			r = 1 if(File.exist?(@controllersDirectory + '/' + controller_file))
			#r = -4
			render :json => [r]
		end	
		
		def delete
			controller_file = @controllersDirectory + '/' + params['name'] + '_controller.rb'
			views_directory = @viewsDirectory + '/' + params['name']
			
			FileUtils.remove_entry(controller_file) if File.exist? (controller_file)
			FileUtils.remove_entry(views_directory) if File.exist? (views_directory)
			
			render :json => [1]
		end
		
		
	end
end

require 'yaml'

module Siel
	class ModelsController < Siel::ApplicationController

		before_action :set_relations
		before_action :set_model
		before_action :set_defined_connections
        
		def index
			@models = FileReader.getModels(@modelsDirectory)
		end
		
		def formatModelName(name)
			chunks = name.gsub(/ +/, '_').split('_').map do |chunk|
				chunk.downcase.capitalize
			end

			chunks.join('')
		end

		def formatFileName(name)
			name.gsub(/ +/, '_').downcase		
		end

		def do_create
			Dir.mkdir(@modelsDirectory, 0777) unless File.exist? @modelsDirectory
			model_name = parseModelName(params[:name])
            model_name = formatModelName(params[:name])
            file_name = formatFileName(params[:name])

			model_pk = params[:pk].strip
			model_table = params[:table_name].strip
			model_file = @modelsDirectory + '/' + file_name + '.rb'
			model_connection = params[:connection].empty? ? '' : params[:connection]
			# model already exist
			render :json => [-1] and return if File.exist? model_file
			template = ERB.new(File.read(File.join(@templatesDirectory, 'model.rb')))
			r = 0
			if isValidName?(model_name)
				File.open(model_file, 'w') do |file|
					file.write(template.result(binding))
					file.close
				end
				r = 1 if File.exist? model_file
			end
			render :json => [r]
		end
		
		def do_edit
			model = Siel::UserModel.unserialize(params[:model])
			
			model.updateLine(:pk, "\tself.primary_key = '" + params[:pk] + "'")
			model.updateLine(:table_name, "\tself.table_name = '" + params[:table_name] + "'")
			unless params[:connection].empty?
				model.updateLine(:connection, "\testablish_connection '" + params[:connection] + "'") 
			else
				model.removeLine(:connection)
			end
			
			r = model.save
			render :json => [r]
		end
        
        def do_raw_edit
            model = getModelByName(params[:name])
            model.setContent(params[:content])
            newName = model.getClassName
            r = 0
            #render :text => newName + ' - ' + params[:name]
            
            #return ''
            unless newName.nil?
                if newName != params[:name]
                    # rename the file
                    File.rename(@modelsDirectory + '/' + params[:name] + '.rb', @modelsDirectory + '/' + newName + '.rb')
                    model.setPath(@modelsDirectory + '/' + newName + '.rb')
                end
                r = model.save
            end
            
            #render :text => model.getContent[0]
            #
            render :json => [r]
        end
        
		def relationships
			@models = FileReader.getModels(@modelsDirectory)
		end
		
		def do_relationships
			model = Siel::UserModel.unserialize(params[:model])
			models = FileReader.getModels(@modelsDirectory)
			associations = {}
			@relationships.each do |type|
				# delete all relations first
				model.deleteLines(Regexp.new(type.to_s))
				unless params[:relations].nil?
					relations = params[:relations][type]
					associations[type] = {}
					if not relations.nil? and relations['name'].length > 0
						key = 0
						relations['name'].each do |name|
							next if name.empty? or name.empty?
							association = ""
							association << type.to_s + ' '
							
							if relations['options'].nil? or relations['options'][key].nil?
								options = {}
							else 
								options = eval(relations['options'][key])
							end
							
							association << ':' + name
							
							options[:class_name] = relations['model'][key]
							unless relations['foreign_key'][key].empty?
								options[:foreign_key] = relations['foreign_key'][key] 
							else
								options.delete(:foreign_key)
							end
							
							options.each do |key, value|
								association << ", #{key}: '#{value}'" 
							end

							#association << ', ' + options.to_s
							associations[type][name] = association
							model.updateLineCustom(Regexp.new(type.to_s + ' :' + name), "\t" + association)
							
							key += 1
						end
					end
				end

			end

			r = model.save
			render :json => [r]
		end
		
		def delete
			model_file = @modelsDirectory + '/' + parseModelName(params[:name]) + '.rb'
			FileUtils.remove_entry(model_file) if File.exist?(model_file)
			r = File.exist?(model_file) ? 0 : 1
			render :json => [r]
		end
		
		
		private
		def set_relations
			@relationships = [:belongs_to, :has_many, :has_one]
		end
		
		def set_defined_connections
			@connections = YAML.load_file(Dir.getwd + '/config/database.yml')
		end
		
		def set_model
			unless params[:model].nil?
				@model = getModelByName(params[:model])
			end
		end
		
		
		
		def isValidName?(name)
			if name =~ /^[\w]+$/
				return true
			end
			return false
		end
	end
end

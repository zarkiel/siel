require 'date'

module Siel
    class MigrationsController < Siel::ApplicationController
        before_action :initializer
        
        def index
			@migrations = getDefinedMigrations
			@actions = ['create', 'add', 'remove']
        end
        
        def do_create
			r = -1
			#params[:name] = params[:name].capitalize
			if isValidName?(params[:name])
				Dir.mkdir(@migrationsDirectory) unless Dir.exist?(@migrationsDirectory)
				r = 1
				className = getMigrationClassName(params[:name])
				fileName = getMigrationFileName(className)
				file = UserFile.new(@migrationsDirectory + '/' + fileName)
				template = ERB.new(File.read(File.join(@templatesDirectory, 'migration.rb')))
				
				action = params[:migration_action]
				table_name = params[:table_name]
				
				File.open(@migrationsDirectory + '/' + fileName, 'w') do |file|
					file.write(template.result(binding))
					file.close
					#exec('rake db:migrate') # executes the migration
				end
			end
			
			render :json => [r, params]
        end
        
        private
        def isValidName?(name)
			if name =~ /^[\w]+$/ and not name =~ / +/
				return true
			end
			return false
		end
		
		def getMigrationFileName(name)
			name = name.split /(?!(^|[a-z]|$))/
			name = name.join('_').downcase
			timestamp = DateTime.now.strftime('%Y%m%d%H%M%S')
			return timestamp.to_s + '_' + name + '.rb'
		end
		
		def getMigrationClassName(name)
			#return name if name[0].to_s =~ /^[A-Z]$/
			firstChar = name[0].to_s.upcase
			return firstChar + name[1, name.length]
		end
		
		def getDefinedMigrations
			files = Dir.glob(File.join(@migrationsDirectory, '*.rb'))
			data = []
			files.each do |file|
				migration_file = File.basename(file)
				migration_name = migration_file[15, migration_file.length].gsub(/\.rb$/, '').split('_').map! do |x|
					x.capitalize
				end
				migration_name = migration_name.join('')
				data.push([migration_name, migration_file])
			end
			return data
		end
		
		def fieldsIterator
			if params[:migration_action] == 'remove' 
				params[:field_type] = []
				params[:field_modifiers] = []
			end
			unless params[:field_name].nil?
				params[:field_name].each_index do |key| 
					next if params[:field_name][key].empty?
					key = key.to_i
					yield(params[:field_name][key], params[:field_type][key], params[:field_modifiers][key])
				end
			end
		end
		
		def initializer
			@migrationsDirectory = Dir.getwd + '/db/migrate'
		end
    end
end

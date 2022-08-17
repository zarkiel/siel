require 'base64'

module Siel
	
	module ApplicationHelper
		
	end
    
    class Scaffold
        
    end
    
    class FileReader
        def self.getModels(models_directory)
			model_files = Dir.glob(models_directory + '/*.rb')
			models = []
			model_files.each do |file|
				models << Siel::UserModel.new(file)
			end
			
			return models
		end
        
        def self.getControllers(controllers_directory)
            controller_files = Dir.glob(controllers_directory + '/*.rb')
			controllers = []
			controller_files.each do |file|
				controller = File.basename(file, '.rb').gsub(/_controller/, '')
				if controller != 'application'
					controllers << controller
				end
			end
            return controllers
        end
    end

	class UserFile
		
		LINE_BREAK = '__zk__';
	
		def initialize(path)
			setPath(path)
			@content = nil
		end

		def setPath(path)
			@path = path
			@name = File.basename(path, '.rb')
		end

		def getReflector
			
		end
		
		def getName
			@name
		end
		
		def getContent
			unless @content
				#@content = File.read(@path).gsub("\n", LINE_BREAK)
				@content = File.read(@path)
			end
			@content
		end

        def setContent(content)
            @content = content
        end
        
		def getLines
			getContent
			return @content.split("\n")
		end
		
		def getFinalContent
			getContent
			cleanString(@content)
		end
		
		def linesIterator
			key = 0
			getLines.each do |line|
				yield(line, key)
				key = key + 1
			end
		end
		
		def lineCommented?(line)
			return line.lstrip[0] == '#'
		end

		def save
			getContent
			file = File.open(@path, 'w')
			r = file.write(getFinalContent)
			file.close()
			return r > 0 ? 1 : 0
		end
		
		def cleanString(str)
			return str.gsub(LINE_BREAK, "\n")
		end
		
		def serialize
			return Base64.encode64(Marshal.dump(self))
		end
	
		def self.unserialize(data)
			return Marshal.load(Base64.decode64(data))
		end
	end

	# HANDLE DE MODEL

	class UserModel < UserFile
		
		@@regexp = {
			:pk => Regexp.new('self.primary_key *= * [\"|\'](\w+)[\"|\']'),
            :class_name => Regexp.new('class (\w+)( <)?'),
			:table_name => Regexp.new('self.table_name *= * [\"|\'](\w+)[\"|\']'),
			#:connection => Regexp.new('establish_connection \$settings\.database_connections\[[\"|\'](\w+)[\"|\']\]'),
			:connection => Regexp.new('establish_connection [\"|\'](\w+)[\"|\']'),
			:end => Regexp.new('end'),
		}
	
		def initialize(path)
			super(path)
		end
		
        def getClassName
            linesIterator do |line|
                match = @@regexp[:class_name].match(line)
                if match
					return match[1]
                end
            end
            return nil
        end
        
		def get_const
			Kernel.const_get(getClassName)
		end
		
		def isActiveRecordModel
			return get_const.ancestors.include? ActiveRecord::Base
		end

		def editable?
			getClassName != 'ApplicationRecord'
		end	
		
		def getTableName
			return get_const.table_name
		end
		
		def getRelations(relation)
			get_const.reflect_on_all_associations(relation)
		end
		
		def getConnection
			linesIterator do |line|
				unless lineCommented?(line)
					match = @@regexp[:connection].match(line)
					if match
						return match[1]
					end
                end
            end
            return '' # default
		end
		
		def getPrimaryKey
			get_const.primary_key
		end
		
		def updateLineCustom(regexp, new_key)
			@@regexp[:custom] = regexp
			return updateLine(:custom, new_key)
		end
		
		def updateLine(regexp_key, new_key)
			unless matchedLine? regexp_key
				appendContent(new_key)
			else
				data = matchedData(regexp_key)
				lineReplace(data[2], data[0], new_key)
			end
		end
		
		def lineReplace(lineno, s1, s2)
			lines = getLines
			lines[lineno] = lines[lineno].lstrip.gsub(s1, s2)
			@content = lines.join("\n")
		end
		
		def matchedLine? regexp_key
			linesIterator do |line, key|
				match = @@regexp[regexp_key].match(line)
				if match and not lineCommented?(line)
					return true
				end
			end
			return false
		end
		
		def removeLine(regexp_key)
			if matchedLine? regexp_key
				data = matchedData(regexp_key)
				lineReplace(data[2], data[0], '')
			end
		end
		
		def matchedData regexp_key
			linesIterator do |line, key|
				match = @@regexp[regexp_key].match(line)
				if match and not lineCommented?(line)
					return [match[0], match[1], key]
				end
			end
			return nil
		end
		
		def deleteLines(regexp)
			lines = getLines
			key = 0
			lines.each do |line|
				match = regexp.match(line)
				if match and not lineCommented?(line)
					lines[key] = nil
				end
				key = key + 1
			end
			@content = lines.compact.join("\n")
		end
		
		def appendContent(content)
			getContent
			lines = getLines
			lines[getEndOfClass] = content + "\n" + lines[getEndOfClass]
			@content = lines.join("\n")
			return @content
		end
		
		def getEndOfClass
			last_line = 0
			linesIterator do |line, lineno|
				match = @@regexp[:end].match(line)
				if match
					last_line = lineno
				end
			end
			return last_line
		end
		
		def self.serializeRelation(relation)
			return Base64.encode64(Marshal.dump(relation))
		end

=begin
		
	
		function getColumns(){
			$name = $this->getName();
			if(!class_exists($name)) return Array();
			return array_keys($name::table()->columns);
		}
		
		function getValidations($validation, $column){
			$name = $this->getName();
			$validation = 'validates_'.$validation.'_of';
			if(isset($name::$$validation)){
				foreach($name::$$validation As $vcolumn){
					if($vcolumn[0] == $column){
						return $vcolumn;
					}
				}
			}
			return Array();
		}
=end
	end
end

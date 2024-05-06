require 'yaml'
require 'fileutils'
module Siel
    module Generators
        class DefaultGenerator

            def initialize(type)
                @type = type
                @command = ARGV[1]
                @template = ARGV[2]
                @template_path = get_template_path(@type, @template)
                raise StandardError.new("Template not found") if !File.exist? @template_path
                raise StandardError.new("Config file 'config.yml' not found") if !File.exist? "#{@template_path}/config.yml"

                @config = YAML.load_file("#{@template_path}/config.yml")
            end

            def execute_command
                send @command if methods.include? @command.to_sym
            end

            def g = generate

            def get_template_path(type, template) = File.expand_path("../../templates/#{type}/#{template}", File.dirname(__FILE__))
            
            def generate_files(context)
                raise StandardError.new("No files defined") if @config["files"].nil? 
                @config["files"].each do |file|
                    source = File.expand_path(file["source"], @template_path)
                    render_file(source, file["destination"], context)
                end
            end

            def render_file(source, destination, context)
                destination = apply_context(destination, context)
                content = apply_context(File.read(source), context)
                FileUtils.mkdir_p(File.dirname(destination)) unless Dir.exist?(File.dirname(destination))
                File.write(destination, content)
            end

            def apply_context(content, context)
                context.keys.each do |key, value|
                    content = content.gsub("${#{key.to_s}}", context[key])
                end
                content
            end
        end
    end
end
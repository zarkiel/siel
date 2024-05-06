require 'yaml'
require 'fileutils'
require 'active_support'

module Siel
    class Generator

        def initialize
            @template = ARGV[1]
            @template_path = get_template_path(@template)
            raise StandardError.new("Template not found") if !File.exist? @template_path
            require File.expand_path("config", @template_path)
            @config = get_config
        end

        def get_template_path(template) = File.expand_path("../templates/#{template}", File.dirname(__FILE__))
        
        def generate = generate_files(@config[:context])

        def generate_files(context)
            raise StandardError.new("No files defined") if @config[:files].nil? 
            @config[:files].each do |file|
                source = File.expand_path(file[:source], @template_path)
                render_file(source, file[:destination], context)
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
require 'active_support'

module Siel
    module Generators
        class RailsGenerator < DefaultGenerator
            def initialize
                super("rails")
            end

            def generate
                controller_name = ARGV[3]
                controller_class_name = ActiveSupport::Inflector.camelize(controller_name)
                singular_name = ActiveSupport::Inflector.singularize(controller_name)
                model_class_name = ActiveSupport::Inflector.camelize(singular_name)
                context = {
                    controller_name: controller_name,
                    controller_class_name: controller_class_name,
                    plural_name: controller_name,
                    singular_name: singular_name,
                    model_class_name: model_class_name,
                }

                generate_files(context)
            end
        end
    end
end
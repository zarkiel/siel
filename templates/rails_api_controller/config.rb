def get_config
    controller_name = ARGV[2]
    controller_class_name = ActiveSupport::Inflector.camelize(controller_name)
    singular_name = ActiveSupport::Inflector.singularize(controller_name)
    model_class_name = ActiveSupport::Inflector.camelize(singular_name)

    {
        files: [
            {
                source: "controller.rb",
                destination: "app/controllers/${controller_name}_controller.rb"
            }
        ],
        context: {
            controller_name: controller_name,
            controller_class_name: controller_class_name,
            plural_name: controller_name,
            singular_name: singular_name,
            model_class_name: model_class_name,
        }
    }
end
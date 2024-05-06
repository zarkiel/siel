class ${controller_class_name}Controller < ApplicationController
	before_action :check_session_token, :initializers
    
    def index
		@${plural_name} = ${model_class_name}.all
        ok(@${plural_name})
	end

    def show = ok(@${singular_name})
    def create = save
	def update = save
	
	def destroy
		@${singular_name}.destroy
		ok(@${singular_name})
	end

	private
	def initializers
		id = params[:id]
		@${singular_name} = id.blank? ? ${model_class_name}.new : ${model_class_name}.find(id)
	end

    def save
        @${singular_name}.attributes = {
		}

		code = -5
		@${singular_name}.save if @${singular_name}.valid?
		ok(@${singular_name})
    end
end

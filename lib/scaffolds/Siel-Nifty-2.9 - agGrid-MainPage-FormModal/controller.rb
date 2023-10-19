class <%=controller_name%> < ApplicationController
	include Nezekan
	
	before_action :initializers
	before_action do |controller|
		secure_action({
			'ADMINISTRADOR' => '*',
		}, session[:USUARIO_ROL])
	end
	def index
		respond_to do |format|
			format.html
			format.json do 
				registros = <%=model_name%>.all.select(<%=object.attributes.map{|attr| ":#{attr[0]}"}.delete_if{|attr| [":created_at", ":updated_at"].include? attr}.join(", ")%>)
				GridHelper.filters(registros, params)
				items = GridHelper.jsonItems(registros) do |registro, item|

				end
				
				render json: items
			end
		end
	end

	def save
		@<%=model_var%>.attributes = {<% object.attributes.each do |key, val| next if ['id', 'created_at', 'updated_at'].include? key %>
			<%=key%>: get_params[:<%=key%>],<% end %>
		}

		code = -5
		if @<%=model_var%>.valid?
			code = @<%=model_var%>.save ? 1 : 0
		end	

		render json: {
			code: code,
			id: @<%=model_var%>.id,
			errors: @<%=model_var%>.errors
		}
	end
	
	def borrar
		code = @<%=model_var%>.destroy ? 1 : 0
		render json: {
			code: code,
			errors: @<%=model_var%>.errors
		}
	end


	private
	def initializers
		id = params[:id] || get_params[:id]
		@<%=model_var%> = (id.nil? or id.empty?) ? <%=model_name%>.new : <%=model_name%>.find_by("sha1(id) = ?", id)
	end

	def get_params
		params.fetch(:<%=model_var%>, {}).permit!
	end

end

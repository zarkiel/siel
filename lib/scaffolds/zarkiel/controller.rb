class <%=controller_name%> < ApplicationController
	include Zarkiel::Forms
	#include Zarkiel::Security
	#before_filter :secure_session
	#@@secure_session = {}
	
	before_filter :getObjectAndForm
	layout false
	
	def index
		@<%=all_var%> = <%=model_name%>.all
	end
	
	def save
		<% object.attributes.each do |key, val| %>
		@<%=model_var%>.<%=key%> = params[:<%=key%>]<% end %>
		
		r = @<%=model_var%>.save ?  1 : 0
		render :json => [r]
	end
	
	def borrar
		r = @<%=model_var%>.destroy ? 1 : 0
		render :json => [r]
	end
	
	private
	def getForm(object)
		options = {
			'id' => {
				'type' => 'hidden'
			}
		}
		
		return Form.new(object, options)
	end
	
	def getObjectAndForm
		@<%=model_var%> = (params[:id].nil? or params[:id].empty?) ? <%=model_name%>.new : <%=model_name%>.find(params[:id])
		if ['editar', 'registrar'].include?(params[:action])
			@form = getForm(@<%=model_var%>)
		end
	end
end

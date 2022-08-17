class <%=model_name%> < ApplicationRecord
	<% unless model_connection.empty? %>establish_connection '<%=model_connection %>'<% end %>
	self.primary_key = '<%=model_pk %>'
	self.table_name = '<%=model_table%>'
end

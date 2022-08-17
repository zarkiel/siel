class <%=className%> < ActiveRecord::Migration[6.1]
	def change
	<%
	unless params[:field_name].nil?
	case action
		when 'create'
		%>
		create_table :<%=table_name %> do |t|
			t.timestamps<% fieldsIterator do |name, type, modifiers| %> 
			t.<%=type %> :<%=name %> <% unless modifiers.empty? %>, <%=modifiers%> <% end %><% end %>

		end
		
		<%

		when 'add' %><% fieldsIterator do |name, type, modifiers| %>
		add_column :<%=table_name %>, :<%=name%>, :<%=type%><% unless modifiers.empty? %>, <%=modifiers%> <% end %><% end %>
		<%
		when 'remove' %><% fieldsIterator do |name, type, modifiers| %>
		remove_column :<%=table_name %>, :<%=name%><% end %>
		<%
	end
	end
	%>
	end
end

module Siel
	class EnvironmentController < Siel::ApplicationController
		
		def index
		

			@params = {
				:session => session
			}
		end
	end	
end

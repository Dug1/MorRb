require_relative "variable_state.rb"
require_relative 'component.rb'

module MorRb

	class Motor < Component
		
		def initialize(hash, port, default_value = 0.0)
			super(hash, port, default_value)
			self.state.alerted do |new_value|
				self.hash.set_motor(self.port, new_value)
			end
		end
	end
	
end
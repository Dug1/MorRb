require_relative 'variable_state.rb'
require_relative 'component.rb'

module MorRb

	class Solenoid < Component
		
		def initialize(hash, port, default_value = false)
			super(hash, port, default_value)
			self.state.alerted do |new_value|
				self.hash.set_solenoid(self.port, new_value)
			end
		end
	end
	
end
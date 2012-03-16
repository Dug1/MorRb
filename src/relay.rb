require_relative 'component.rb'

module MorRb

	class Relay < Component
		
		def initialize(hash, port, default = 0)
			super(hash, port, default)
			self.state.alerted do |new_value|
				self.hash.set_relay(self.port, new_value)
			end
		end
	end
end
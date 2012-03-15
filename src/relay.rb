require_relative 'component.rb'

module MorRb

	class Relay < Component
		
		def self.at(hash, port, default_value = 0)
			@@relays = {} unless class_variable_defined?(:@@relays)
			(@@relays[port] = self.new(hash, port, default_value)) unless @@relays.key?(port)
			@@relays[port]
		end
	
		def self.all
			@@relays
		end
		
		def self.clear_all
			@@relays.clear if class_variable_defined?(:@@relays)
		end
		
		def initialize(hash, port, default)
			super(hash, port, default)
			self.state.alerted do |new_value|
				self.hash.set_relay(self.port, new_value)
			end
		end
	end
end
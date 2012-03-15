require_relative 'variable_state.rb'
require_relative 'component.rb'

module MorRb

	class Solenoid < Component
		
		def self.at(hash, port, default_value = false)
			@@solenoids = {} unless class_variable_defined?(:@@solenoids)
			(@@solenoids[port] = self.new(hash, port, default_value)) if !@@solenoids.key? port
			@@solenoids[port]
		end
		
		def self.clear_all
			@@solenoids.clear if !defined?(@@solenoids).nil?
		end
		
		def self.all
			@@solenoids
		end
		
		def initialize(hash, port, default_value)
			super(hash, port, default_value)
			self.state.alerted do |new_value|
				self.hash.set_solenoid(self.port, new_value)
			end
		end
	end
	
end
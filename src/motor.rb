require_relative "variable_state.rb"
require_relative 'component.rb'

module MorRb

	class Motor < Component
		
		def self.at(hash, port, default_value = 0.0)
			@@motors = {} unless class_variable_defined?(:@@motors)
			(@@motors[port] = self.new(hash, port, default_value)) if !@@motors.key?(port)
			@@motors[port]
		end
		
		def self.clear_all
			@@motors.clear if !defined?(@@motors).nil?
		end
		
		def self.all
			@@motors
		end
		
		def initialize(hash, port, default_value)
			super(hash, port, default_value)
			self.state.alerted do |new_value|
				self.hash.set_motor(self.port, new_value)
			end
		end
	end
	
end
require_relative 'variable_state.rb'

module MorRb

	class Component
		attr_accessor :port, :default,:hash 
		attr_reader :state
	
		def initialize(hash, port, default)
			@hash = hash
			@default = default
			@port = port
			@state = VariableState.new(@default)
		end
		
		def set(value)
			@state.value = value
		end
		
		def get()
			@state.value
		end
		
		def reset
			@state.value = @default
		end
	end
end
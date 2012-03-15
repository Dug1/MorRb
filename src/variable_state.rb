module MorRb
	class VariableState 
		attr_accessor :value
		
		def initialize(variable, handlers = [], &condition)
			@value = variable
			@handlers = handlers
			@condition = condition||Proc.new {|old, new| old != new}
		end
		
		def alerted(&handler)
			@handlers << handler
		end
		
		def value=(newValue) 
			if @condition.call(@value, newValue)
				@value = newValue
				@handlers.each {|e| e.call(newValue)}
			end
		end
		
		def alert_when(&condition)
			@condition = condition
		end
	end
end
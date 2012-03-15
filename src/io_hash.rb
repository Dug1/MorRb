module MorRb
	
	class IOHash
		
		def set_motor(port, value)
			puts "motor #{port} set to #{value}"
		end
		
		def set_solenoid(port, value)
			puts "solenoid #{port} set to #{value}"
		end
		
		def set_relay(port, value)
			puts "relay #{port} set to #{value}"
		end
		
	end
	
end
require_relative 'io_hash.rb'


module MorRb
	
	class Robot
		@lf = 1
		@rf = 2
		@lb = 3
		@rb = 4
		
		def initialize
			@hash = IOHash.new
		end
		
		def motor(port)
			Motor.at(@hash, port)
		end
		
		def solenoid(port)
			Solenoid.at(@hash, port)
		end
		
		def relay(port)
			Relay.at(@hash, port)
		end
		
		def drive(joystick)
			x = joystick.axis(0)
			y = joystick.axis(1)
			throttle = (-joystick.axis(2) + 1)*0.4 + 0.2 
			
			self.motor(@lf).set(throttle * (x - y))
			self.motor(@rf).set(throttle * (x - y))
			self.motor(@lb).set(throttle * (-x - y))
			self.motor(@rb).set(throttle * (-x - y))
		end
		
	end
end
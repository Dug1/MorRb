require_relative 'io_hash.rb'
require_relative 'motor.rb'
require_relative 'solenoid.rb'
require_relative 'relay.rb'
require 'drb/drb'


module MorRb
	class Robot
		include DRb::DRbUndumped
		
		def initialize
			@lf = 1
			@rf = 2
			@lb = 3
			@rb = 4
			@bot_con = 6   
			@fly_1 = 7
			@fly_2 = 8
			@top_con = 9
			@hash = IOHash.new
			@motors = {}
			@solenoids = {}
			@relays = {}
		end
		
		def motor(port)
			(@motors[port] = Motor.new(@hash, port)) unless @motors.key?(port)
			@motors[port]
		end
		
		def solenoid(port)
			(@solenoids[port] = Solenoid.new(@hash, port))  unless @solenoids.key?(port)
			@solenoids[port]
		end
		
		def relay(port)
			(@relays[port] = Relay.new(@hash, port)) unless @relays.key?(port)
			@relays[port]
		end
		
		def clear_components
			@motors.clear
			@solenoids.clear
			@relays.clear
		end
		
		def drive(joystick)
			x = 1.0 #joystick.axis(0)
			y = 1.0 #joystick.axis(1)
			throttle = (-joystick.axis(2) + 1)*0.4 + 0.2 
			
			self.motor(@lf).set(throttle * (x - y))
			self.motor(@rf).set(throttle * (x - y))
			self.motor(@lb).set(throttle * (-x - y))
			self.motor(@rb).set(throttle * (-x - y))
		end
		
		def flywheel(direction)
			self.motor(@fly_1).set(direction.to_f)
			self.motor(@fly_2).set(direction.to_f)
		end
		
		def bot_con(direction)
			self.motor(@bot_con).set(direction.to_f)
		end
		
		def top_con(direction)
			self.motor(@top_con).set(direction.to_f)
		end
		
		def hammer(value)
			self.solenoid(1).set(!value)
			self.solenoid(2).set(value)
		end
		
		def compressor(value)
			if(value)
				self.relay(1).set(1)
			else
				self.relay(1).set(0)
			end
		end
		
		def reset
			@motors.each {|motor| motor.set(0.0)}
			@solenoid[1] 
			@solenoid[2]
		end
	end
end
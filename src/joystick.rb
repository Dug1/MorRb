require 'sdl'
require_relative 'variable_state.rb'

module MorRb
	class Joystick
		SDL.init(SDL::INIT_JOYSTICK)
		@@axis_max = 32768
		
		def Joystick.poll
			SDL::Joystick.update_all
		end
		
		def initialize(joystick) 
			@joystick = joystick
			@axes = []
			@buttons = []
			@joystick.num_axis.times {|x| @axes[x] = VariableState.new(@joystick.axis(x))}
			@joystick.num_buttons.times {|x| @buttons[x] = VariableState.new(@joystick.button(x))}
		end
		
		def axis(port)
			@axes[port]
		end
		
		def button(port)
			@buttons[port]
		end
		
		def update
			Joystick.poll
			0.upto(@axes.size - 1) do |x|
				@axes[x].value = @joystick.axis(x).to_f/@@axis_max 
			end
			0.upto(@buttons.size - 1) do |x|
				@buttons[x].value = @joystick.button(x)
			end
		end
		
		def close
			@joystick.close
		end
	end
end
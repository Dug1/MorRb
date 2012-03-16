require 'drb/drb'
require 'sdl'
require_relative 'robot.rb'
require_relative 'joystick.rb'

URL = "druby://localhost:1515"

class RobotServer
	
	def initialize
		@robot = MorRb::Robot.new
		#@joystick = MorRb::Joystick.new(SDL::Joystick(0))
		#@joystick.axis(0).alerted do
		#	@@reactor.schedule {@@robot.drive(@joystick)}
		#end
		#@joystick.axis(1).alerted do
		#	@@reactor.schedule {@@robot.drive(@joystick)}
		#end
		#@joystick.axis(2).alerted do
		#	@@reactor.schedule {@@robot.drive(@joystick)}
		#end
		#@poll_thread = Thread.new do 
		#	while true
		#		@joystick.update
		#	end
		#end
		#@poll_thread .stop
	end
	
	def robot
		@robot
	end	
	
	def open_joystick
		#@poll_thread.run
	end
	
	def joystick
		#@joystick
	end
	
	def close_joystick
		#@poll_thread.stop
	end
end

OBJECT = RobotServer.new

DRb.start_service(URL, OBJECT)
DRb.thread.join
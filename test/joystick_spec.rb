require_relative '../src/joystick.rb'
require 'sdl'

describe MorRb::Joystick do

	before :each do
		@max = 32768
		joystick_stub = double("SDL::joystick")
		joystick_stub.stub(:axis).with(0).and_return(0.1*@max,0.2*@max)
		joystick_stub.stub(:axis).with(1).and_return(0.4*@max,0.5*@max,0.6*@max)
		joystick_stub.stub(:button).with(0).and_return(false, false, true)
		joystick_stub.stub(:num_axis).and_return(2)
		joystick_stub.stub(:num_buttons).and_return(1)
		@joystick = MorRb::Joystick.new(joystick_stub)
	end
	
	it "should init" do
		@joystick.should be_an_instance_of(MorRb::Joystick)
		SDL.inited_system(SDL::INIT_JOYSTICK).should eq(SDL::INIT_JOYSTICK)
	end
	
	it "should alert listeners when axis changes" do
		handler = double("handler")
		handler.should_receive(:call).once
		@joystick.axis(0).alerted do |x|
			handler.call(x)
		end
		
		@joystick.update
		@joystick.update
	end
	
	it "should sort axis alerts" do
		handler_one = double("handler1")
		handler_one.should_receive(:call).once
		handler_two = double("handler2")
		handler_two.should_receive(:call).twice
		@joystick.axis(0).alerted do |x|
			handler_one.call(x)
		end
		@joystick.axis(1).alerted do |x|
			handler_two.call(x)
		end
		
		@joystick.update
		@joystick.update
		@joystick.update
	end
	
	it "should support button alerts" do
		handler = double("handler")
		handler.should_receive(:call).with(true).once
		@joystick.button(0).alerted do |x|
			handler.call(x)
		end
		
		@joystick.update
		@joystick.update
		@joystick.update
	end
end
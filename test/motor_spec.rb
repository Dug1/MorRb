require_relative '../src/motor.rb'

describe MorRb::Motor do

	it "should init" do
		io_hash = double("IOHash")
		io_hash.stub(:set_motor)
		@motor = MorRb::Motor.new(io_hash,2,0.0)
		@motor.should be_an_instance_of(MorRb::Motor)
		@motor.port.should eq(2)
	end
	
	it "should fire to IOHash on change" do
		io_hash = double("IOHash2")
		io_hash.stub(:set_motor)
		io_hash.should_receive(:set_motor).with(2, 0.5)
		
		@motor = MorRb::Motor.new(io_hash,2,0.25)
		@motor.get.should eq(0.25)
		
		@motor.set(0.0)
		@motor.set(0.5)
		@motor.set(0.5)
		@motor.get.should eq(0.5)
	end
end
require_relative '../src/motor.rb'

describe MorRb::Motor do

	before :each do
		MorRb::Motor.clear_all
	end

	it "should init" do
		io_hash = double("IOHash")
		io_hash.stub(:set_motor)
		@motor = MorRb::Motor.at(io_hash,2,0.0)
		@motor.should be_an_instance_of(MorRb::Motor)
		@motor.port.should eq(2)
		second_motor = MorRb::Motor.at(io_hash,2)
		second_motor.should be(@motor)
		MorRb::Motor.all.size.should eq(1)
	end

	it "should clear" do
		MorRb::Motor.at(double(:set_motor => nil), 1)
		MorRb::Motor.all.size.should eq(1)
		MorRb::Motor.clear_all
		MorRb::Motor.all.size.should eq(0)
	end

	it "should fire to IOHash on change" do
		io_hash = double("IOHash2")
		io_hash.stub(:set_motor)
		io_hash.should_receive(:set_motor).with(2, 0.5)
		
		@motor = MorRb::Motor.at(io_hash,2,0.25)
		@motor.get.should eq(0.25)
		
		@motor.set(0.0)
		@motor.set(0.5)
		@motor.set(0.5)
		@motor.get.should eq(0.5)
	end
end
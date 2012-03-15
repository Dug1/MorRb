require_relative '../src/solenoid.rb'

describe MorRb::Solenoid do

	before :each do
		MorRb::Solenoid.clear_all
	end

	it "should init" do
		io_hash = double("IOHash")
		io_hash.stub(:set_solenoid)
		@solenoid = MorRb::Solenoid.at(io_hash,2,false)
		@solenoid.should be_an_instance_of(MorRb::Solenoid)
		@solenoid.port.should eq(2)
		second_Solenoid = MorRb::Solenoid.at(io_hash,2)
		second_Solenoid.should be(@solenoid)
		MorRb::Solenoid.all.size.should eq(1)
	end

	it "should clear" do
	
		MorRb::Solenoid.at(double(:set_solenoid => nil), 1)
		MorRb::Solenoid.all.size.should eq(1)
		MorRb::Solenoid.clear_all
		MorRb::Solenoid.all.size.should eq(0)
	end

	it "should fire to IOHash on change" do
		io_hash = double("IOHash2")
		io_hash.stub(:set_solenoid)
		io_hash.should_receive(:set_solenoid).with(2, true)
		
		@solenoid = MorRb::Solenoid.at(io_hash,2,false)
		@solenoid.get.should eq(false)
		
		@solenoid.set(false)
		@solenoid.set(true)
		@solenoid.set(true)
		@solenoid.get.should eq(true)
	end
end
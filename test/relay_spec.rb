require_relative '../src/relay.rb'

describe MorRb::Relay do

	before :each do
		MorRb::Relay.clear_all
	end

	it "should init" do
		io_hash = double("IOHash")
		io_hash.stub(:set_relay)
		@relay = MorRb::Relay.at(io_hash,2,0)
		@relay.should be_an_instance_of(MorRb::Relay)
		@relay.port.should eq(2)
		second_Relay = MorRb::Relay.at(io_hash,2)
		second_Relay.should be(@relay)
		MorRb::Relay.all.size.should eq(1)
	end

	it "should clear" do
		MorRb::Relay.at(double(:set_relay => nil), 1)
		MorRb::Relay.all.size.should eq(1)
		MorRb::Relay.clear_all
		MorRb::Relay.all.size.should eq(0)
	end

	it "should fire to IOHash on change" do
		io_hash = double("IOHash")
		io_hash.stub(:set_relay)
		io_hash.should_receive(:set_relay).with(2, -1).once
		
		@relay = MorRb::Relay.at(io_hash,2,0)
		@relay.get.should eq(0)
		 
		@relay.set(0)
		@relay.set(-1)
		@relay.set(-1)
		@relay.get.should eq(-1)
	end
end
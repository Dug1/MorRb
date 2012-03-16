require_relative '../src/relay.rb'

describe MorRb::Relay do

	it "should init" do
		io_hash = double("IOHash")
		io_hash.stub(:set_relay)
		@relay = MorRb::Relay.new(io_hash,2,0)
		@relay.should be_an_instance_of(MorRb::Relay)
		@relay.port.should eq(2)
	end

	it "should fire to IOHash on change" do
		io_hash = double("IOHash")
		io_hash.stub(:set_relay)
		io_hash.should_receive(:set_relay).with(2, -1).once
		
		@relay = MorRb::Relay.new(io_hash,2,0)
		@relay.get.should eq(0)
		 
		@relay.set(0)
		@relay.set(-1)
		@relay.set(-1)
		@relay.get.should eq(-1)
	end
end
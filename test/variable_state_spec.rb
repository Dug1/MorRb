require_relative '../src/variable_state.rb'

describe MorRb::VariableState do
	
	it "should init" do
		@x = MorRb::VariableState.new(7)
		@x.value.should eq(7)
	end
	
	it "should alert childern on change" do
		@handler = double("handler")
		@handler.should_receive(:call).with(8).twice
		@x = MorRb::VariableState.new(7)
		
		@x.alerted do |x|
			@handler.call(x)
		end
		@x.alerted do |x|
			@handler.call(x)
		end
		@x.value = 8
	end
	
	it "should allow custom checking" do
		@handler = double("handler")
		@handler.should_receive(:call).once
		@x = MorRb::VariableState.new(7) {|old, new| old < new}
		
		@x.alerted do |new|
			@handler.call(new)
		end
		
		@x.value = 8
		@x.value = 7
	end
end
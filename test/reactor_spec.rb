require_relative '..\src\reactor.rb'

describe MorRb::Reactor do
	
	after :each do 
		@reactor.kill
	end
	
	it "should init" do
		@reactor = MorRb::Reactor.new
		@reactor.should be_an_instance_of(MorRb::Reactor)
	end
	
	it "should execute commands" do
		@reactor = MorRb::Reactor.new
		handler = double("handler")
		handler.should_receive(:no_args).twice
		handler.should_receive(:two_args).with(1,true).once
		@reactor.schedule(Proc.new { handler.no_args })
		@reactor.schedule do
			handler.no_args
		end
		@reactor.schedule(1,true) do |x,y|
			handler.two_args(x,y)
		end
		
		sleep(0.5)
	end
	
	it "should handle delays" do
		handler = double("handler")
		handler.should_receive(:call).once
		
		@reactor = MorRb::Reactor.new
		@reactor.schedule do
			sleep(0.5)
			handler.call
		end
		
		sleep(1)
	end
	
	it "should shutdown and start-up" do
		handler = double("handler")
		handler.should_receive(:call).once
		
		@reactor = MorRb::Reactor.new
		@reactor.schedule do
			sleep(0.5)
			handler.call
		end
		
		@reactor.shutdown
		@reactor.schedule do
			sleep(0.5)
			handler.call
		end
		
		sleep(0.1)
		
		@reactor.alive?.should eq(false)
		@reactor.tasks.size.should eq(0)
		Thread.list.size.should eq(2)
		
		sleep(1)
		
		@reactor.restart
		@reactor.schedule do
			handler.call
		end
	
		sleep(0.1)
	end
end
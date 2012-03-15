module MorRb
	class Reactor
		attr_reader :tasks, :threads
		
		def initialize
			@tasks = []
			@threads = []
			@alive = true
			@poll = Thread.new do
				while true
					Thread.stop if check_queue
				end
			end
			@poll.priority = -2
		end
		
		def schedule(*args, &block)
			if(@alive)
				to_do = args[0].instance_of?(Proc) ? args.delete_at(0) : block
				@tasks << [args, to_do] 
				@poll.run
			end
		end
		
		def check_queue
			unless(@tasks.empty?)
			args, to_do = @tasks.delete_at(0)
				t = Thread.new do
					to_do.call args
					@threads.delete(t)
				end
				@threads << t
				return false
			end
			return true
		end
		
		def kill
			@poll.kill
			shutdown
		end
		
		def restart
			@alive = true
		end
		
		def shutdown
			@alive = false
			clear
		end
		
		def clear
			@threads.each {|t| Thread.kill(t) if t.alive?}
			@tasks.clear
			@threads.clear
		end
		
		def alive?
			@alive
		end
		
		private :check_queue
	end
end
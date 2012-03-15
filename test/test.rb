@threads = []

t = Thread.new do
	sleep(1)
	puts 'c'
	@threads.remove(t)
end

@threads << t

sleep(0.4)
t.kill

t.join
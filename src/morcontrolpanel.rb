require 'variable_state.rb'
require 'robot.rb'
require 'reactor.rb'
require 'morwidgets.rb'
require 'sdl'


class MorTorqControlPanel < Shoes
	url '/' , :index
	url '/Home' , :index
	url '/Stop', :stop
	url '/DriveTrain' , :drive_train
	url '/Turret' , :turret
	url '/Conveyor' , :conveyor
	url '/Game' , :game
	url '/Hammer', :hammer
	
	def header(current_screen)
		@screens = ["Home","Game","DriveTrain","Conveyor","Turret","Hammer"]
		tab_width = 1.0/@screens.size
		flow :width => "100%", :height => 38 do 
			@screens.each do |name|
				if(current_screen != name)
					tab = flow :width => tab_width do
						background gold..orange
						caption(name).style(:align => true, :align => "center", :stroke => gray)
					end
					
					tab.hover do 
						tab.clear do
							background orange..dimgray
							caption(name).style(:align => true, :align => "center", :stroke => white)
						end
					end
					
					tab.leave do 
						tab.clear do
							background gold..orange
							caption(name).style(:align => true, :align => "center", :stroke => gray)
						end
					end
					
					tab.click do
						@@reactor.shutdown
						visit('/' + name.to_s)
						@@reactor.restart
						@joystick.close if instance_variable_defined?(:@joystick)
					end
				else
					tab = flow :width => tab_width do
						background orange..dimgray
						caption(name).style(:align => true, :align => "center", :stroke => white)
					end
				end
			end
		end
	end
	
	def draw_stop
		fill red
		stroke white
		strokewidth = 5
		redstop = oval(:radius => 75,:top => 275, :left => 512, :center => true)
		subtitle = subtitle("STOP")
		subtitle.style(:top => 251, :left => 460, :center => true, :stroke => white)
		redstop.click do 
			@@reactor.shutdown
			visit('/Stop')
		end
	end
	
	def index
		@@reactor = MorRb::Reactor.new() unless defined?(:@@reactor).nil?
		@@robot = MorRb::Robot.new() unless defined?(:@@robot).nil?
		@@reactor.shutdown
		background "#222".."#444"
		stack do 
			header "Home" 
		end
	end
	
	def drive_train
		
		background "#222".."#444"
		header "DriveTrain"
		flow(:height => -38, :width => "100%") do
			tl = speedometer(:height => 200, :width => 200, :top => 50, :left => 222)
			tr = speedometer(:height => 200, :width => 200, :top => 325, :left => 222)
			bl = speedometer(:height => 200, :width => 200, :top => 50, :left => 600)
			br = speedometer(:height => 200, :width => 200, :top => 325, :left => 600)
			
			shifter(:height => 200, :width => 100, :top => 25, :left => 100).state.alerted do |x|
				tl.state.value = (2*x - 1).abs
			end
			shifter(:height => 200, :width => 100, :top => 300, :left => 100).state.alerted do |x|
				tr.state.value = (2*x - 1).abs
			end
			shifter(:height => 200, :width => 100, :top => 25, :left => 874).state.alerted do |x|
				bl.state.value = (2*x - 1).abs
			end
			shifter(:height => 200, :width => 100, :top => 300, :left => 874).state.alerted do |x|
				br.state.value = (2*x - 1).abs
			end
			
			draw_stop
		end
	end 
	
	def turret
		background "#222".."#444"
		header "Turret" 
		#caption("WTF!!!!").move(350, 200).style(:size => 200, :stroke => red, :align => 'center')
		#draw_stop
	end
	
	def conveyor
		background "#222".."#444"
		header "Conveyor" 
		flow(:height => -38, :width => "100%") do
			stack :center => true, :left => 712, :top => 150, :height => 280, :width => 200 do
				subtitle("Bottom").style(:align => 'center', :stroke => white)
				bot_shifter = shifter(:height => 200, :width => 100).move(25,60)
				text_button(:left => 125, :top => 135,:height => 50, :width => 50, :toggle => false, :text => 'Zero', :on_color => orange(0.5), :off_color => orange(0.5)).state.alerted do |pressed|
					bot_shifter.state.value = 0.5 if pressed
				end
			end
			stack :center => true, :left => 112, :top => 150, :height => 280, :width => 200 do
				subtitle("Top").style(:align => 'center', :stroke => white)
				top_shifter = shifter(:height => 200, :width => 100).move(125,60)
				text_button(:left => 25, :top => 135,:height => 50, :width => 50, :toggle => false, :text => 'Zero', :on_color => orange(0.5), :off_color => orange(0.5)).state.alerted do |pressed|
					top_shifter.state.value = 0.5 if pressed
				end
			end
			draw_stop
		end
	end
	
	def game
		#@joystick = Joystick.new(SDL::Joystick.open(0))
		#@joystick.axis(1).alerted do
		#	@@reactor.schedule {@@robot.drive(@joystick)}
		#end
		#@joystick.axis(2).alerted do
		#	@@reactor.schedule {@@robot.drive(@joystick)}
		#end
		#@joystick.axis(3).alerted do
		#	@@reactor.schedule {@@robot.drive(@joystick)}
		#end
		
		background "#222".."#444"
		header "Game" 
		flow :width => "100%", :height => -38 do
			stack :top => 50, :left => 712, :width => 200, :height => 400 do
				fire = shape_button :toggle => false do
					shape :width => 200, :height => 200 do 
						stroke green
						nofill
						strokewidth 4
						oval(:top => 100, :left => 100, :radius => 80, :center => true)
						oval(:top => 100, :left => 100, :radius => 10, :center => true)
						line(0,100,200,100)
						line(100,0,100,200)
					end 
				end
				fire.when_on do |part|
					part['base'].style(:stroke => red)
				end
				fire.when_off do |part|
					part['base'].style(:stroke => green)
				end
				
				text_button(:left => 0, :top => 210,:height => 65, :width => 200, :toggle => false, :text => "Pick-Up", :on_color => red(0.5), :off_color => orange(0.5))
				text_button(:left => 0, :top => 300,:height => 65, :width => 200, :toggle => false, :text => "Purge", :on_color => red(0.5), :off_color => orange(0.5))
				
				fire.state.alerted do |i|
					@@reactor.schedule(i) do |x|
						@@robot.set_motor()
			end
			draw_stop
		end
	end
	
	def hammer
		background "#222".."#444" 
		header "Hammer"
		flow :width => "100%", :height => -38 do
			@hammer = shape_button(:toggle => true) do |part|
				flow(:top => 100, :left => 100, :height => 300, :width => 300) do 
					fill green
					nostroke
					rect(:top => 60, :left => 215, :width => 20, :height => 190, :curve => 8)
					rect(:top => 50, :left => 150, :width => 150, :height => 75, :curve => 8)
				end
			end
			
			@hammer.when_on do |part|
				part['base'].clear
				part['base'].append do
					fill red
					nostroke
					rect(:top => 215, :left => 60, :width => 190, :height => 20, :curve => 8)
					rect(:top => 150, :left => 50, :width => 75, :height => 150, :curve => 8)
					star(70,300,10,75.0,25.0)
				end
			end
			
			@hammer.when_off do |part|
				part['base'].clear
				part['base'].append do
					fill green
					nostroke
					rect(:top => 60, :left => 215, :width => 20, :height => 190, :curve => 8)
					rect(:top => 50, :left => 150, :width => 150, :height => 75, :curve => 8)
				end
			end
			
			@compressor_control = flow(:top => 150, :left => 612, :width => 200, :height => 200) do
				@compressor_manual = MorRb::VariableState.new(false)
				fill orange(0.5)
				nostroke
				
				compressor_switch = shape_button do |part|
					flow :top => 50, :width => 200, :height => 150 do
						part['compressor'] = shape :width => 200, :height => 150 do
							nostroke
							fill red
							oval(:top => 50, :left => 25, :height => 75, :width => 25)
							oval(:top => 50, :left => 150, :height => 75, :width => 25)
							rect(:top => 49, :left => 38, :height => 76, :width => 125, :curve => 2)
							rect(:top => 25, :left => 45, :height => 10, :width => 125, :curve => 2)
							rect(:top => 21, :left => 36, :height => 16, :width => 32, :curve => 6)
							rect(:top => 30, :left => 38, :height => 30, :width => 26)
						end
						part['caption'] = subtitle("OFF").style(:align => 'center', :top => 65, :stroke => white)
					end
				end
				compressor_switch.hide
				
				compressor_switch.when_on do |part| 
					part['compressor'].style(:fill => green)
				   	part['caption'].replace("ON")
				end
				
				compressor_switch.when_off do |part|
					part['compressor'].style(:fill => red)
				   	part['caption'].replace("OFF")
				end
				
				compressor_manuality = stack(:top => 0, :left => 0, :width => 200, :height => 200) do
					subtitle("Compressor Manual").style(:top => 50, :align => 'center', :stroke => white)
					rect(:width => 200, :height => 200, :curve => 10)
				end
				
				compressor_manuality.click do
					compressor_manuality.clear
					@compressor_manual.value = !@compressor_manual.value
					if(@compressor_manual.value)
						compressor_manuality.style(:height => 50)
						compressor_switch.show
						compressor_manuality.append do
							caption("Compressor Auto").style(:top => 10, :align => 'center', :stroke => white)
							rect(:width => 200, :height => 50, :curve => 10)
						end
					else
						compressor_manuality.style(:height => 200)
						compressor_switch.hide
						compressor_manuality.append do
							subtitle("Compressor Manual").style(:top => 50, :align => 'center', :stroke => white)
							rect(:width => 200, :height => 200, :curve => 10)
						end
					end
				end
			end
		end
		draw_stop
	end
	
	def stop
		background red..darkred
		home = stack :width => 1.0, :height => 38 do
			background gold..orange
			caption("Home").style(:align => 'center', :stroke => gray, :size => 18)
		end
		
		home.click do 
			visit('/Home')
		end
		
		banner("STOPPED").style(:align => 'center', :stroke => white, :size => 80, :top => 200)
	end
end

Shoes.app
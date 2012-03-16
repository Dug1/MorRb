require_relative 'variable_state.rb'

module MorRb
	class TextButton < Shoes::Widget
		attr_accessor :state
		
		def initialize(opts = {})
			@height = opts.fetch(:height, 50)
			@width = opts.fetch(:width, 100)
			@off_color = opts.fetch(:off_color, red(0.5))
			@on_color = opts.fetch(:on_color, green(0.5))
			@text = opts.fetch(:text, "TEXT")
			@on_text = opts.fetch(:on_text, @text)
			@off_text = opts.fetch(:off_text, @text)
			@toggle = opts.fetch(:toggle, true)
			@state = VariableState.new(opts.fetch(:state, false))
			
			stack :height => @height, :width => @width do
				nostroke
				@text = para(@off_text).style(:top => @height/2 - @height/3, :size => (@height/3).to_i, :align => 'center', :stroke => white)
				@box = rect(:top=> 0, :left => 0, :width => @width, :height => @height, :curve => 6, :center => false)
			end
			
			if(@state.value)
				draw_on
			else
				draw_off
			end
			
			@state.alerted do |on|
				if(on)
					draw_on
				else
					draw_off
				end
			end
			
			if @toggle
				@box.click do
					@state.value = !@state.value
				end
			else
				@box.click do 
					@state.value = true
				end
				
				@box.release do
					@state.value = false
				end
				
				@box.leave do
					@state.value = false
				end
			end
		end
		
		def draw_on
			@box.style(:fill => @on_color)
			@text.replace(@on_text)
		end
		
		def draw_off
			@box.style(:fill => @off_color)
			@text.replace(@off_text)
		end
	end
	
	class ShapeButton < Shoes::Widget
		attr_accessor :state
		
		def initialize(opts = {}, &init)
			@toggle = opts.fetch(:toggle, true)
			@state = VariableState.new(opts.fetch(:state, false))
			@init = init||Proc.new { rect(0,0,200, 200)}
			@parts = {}
			
			@base = @init.call(@parts)
			
			@parts['base'] = @base 
			
			@state.alerted do |on|
				if(on)
					@on_proc.call(@parts) if self.instance_variable_defined?(:@on_proc)
				else
					@off_proc.call(@parts) if self.instance_variable_defined?(:@off_proc)
				end
			end
			
			if @toggle
				@base.click do
					@state.value = !@state.value
				end
			else
				@base.click do 
					@state.value = true
				end
				
				@base.release do
					@state.value = false
				end
				
				@base.leave do
					@state.value = false
				end
			end
		end
		
		def when_on(&draw_on)
			@on_proc = draw_on
		end
		
		def when_off(&draw_off)
			@off_proc = draw_off
		end
	end

	class Shifter < Shoes::Widget
		attr_accessor :width, :height, :top, :left, :state
		
		def initialize(opts = {})
			@height = opts.fetch(:height, 100)
			@width = opts.fetch(:width, 50)
			value = opts.fetch(:value, 0)
			@slider_height = height - 40
			@state = VariableState.new(value)
			
			nostroke
			stack :height => @height, :width => @width do 
				fill gray
				rect(:top=> @height/2, :left => @width/4, :width => 4, :height => @slider_height, :curve => 2, :center => true)
				fill orange(0.5)
				@slider = rect(:top => @height - (@slider_height*value + 20), :height => 40, :width => @width, :center => true, :curve => 2)
				
				click do 
					@slider_held = true
				end
				
				release do 
					@slider_held = false
				end
				
				motion do |x,y|
					if(@slider_held) && y >= 20 && y <= @slider_height + 20
						@state.value = (@slider_height - y + 20).to_f/@slider_height
					end
				end
			end
			
			@state.alerted do |value|
				@slider.top = @slider_height + 20 - value*@slider_height
			end
		end
	end
	
	class Speedometer < Shoes::Widget 
		attr_accessor :height, :width, :state
		
		def initialize(opts={}) 
			@height = opts.fetch(:height, 100)
			@width =  opts.fetch(:width, 50)
			@state = VariableState.new(0.0)
			@stroke_width = 4
			
			stack :height => @height, :width => @width do
				stroke aqua(0.8)
				strokewidth @stroke_width
				nofill
				
				arc(@width/2, @height/2, @width-@stroke_width, @height-@stroke_width, 5*Math::PI/6, Math::PI/6)
				arc(@width/2, @height/2, @width/2, @height/2, 5*Math::PI/6, Math::PI/6)
		
				tick = 10
				0.upto(tick) do |i|
					if(i == 0 || i == tick)
						draw_radial_line -Math::PI/6 + (4*i*Math::PI)/(3 * tick), 0.3*(@height/2)..(@height/2)
					else
						draw_radial_line -Math::PI/6 + (4*i*Math::PI)/(3 * tick), 0.9*(@height/2 - 2)..(@height/2 - 2)
					end
				end
				stroke red
				oval(:left => @width/2, :top => @height/2, :radius => 8, :center => true)
				@needle = draw_radial_line((7*Math::PI/6 - opts.fetch(:value, 0)*(4*Math::PI)/(3)), 0..0.8*@height/2-2) 
				
				@state.alerted do |value|
					@needle.remove if self.instance_variable_defined?(:@needle)
					prepend do
						stroke red
						strokewidth @stroke_width
						@needle = draw_radial_line((7*Math::PI/6 - value*(4*Math::PI)/(3)), 0..0.8*@height/2-2) 
					end
				end
			end
		end
		
		def draw_radial_line(radians, range)
			start_x = Math.cos(radians)*range.begin + @width/2
			start_y = -Math.sin(radians)*range.begin + @height/2
			end_x = Math.cos(radians)*range.end + @width/2
			end_y = -Math.sin(radians)*range.end  + @height/2
			
			line(start_x, start_y, end_x, end_y)
		end
	end
end 

#Shoes.app do
#	background "#222".."#444"
#	stack do 
#		@speedometer = speedometer(:height => 200, :width => 200)
#		#@shifter = shifter({:value => 0.5, :height => 200, :width => 200})
#		#@shifter.state.alerted do |value|
#		#	@speedometer.state.value = value
#		#end
#	end
#	#hello = button "hello" 
#	#okay =	button "okay" 
#	#yay = button "yay"
#	#
#	#@para = para "hello"
#	#@radio = MorWidgets::CustomRadio.new({:children => [hello, okay, yay]})
#	#@radio.when_on(1) do 
#	#	@para.text = "hello"
#	#end
#	#@radio.when_on(2) do 
#	#	@para.text = "okay"
#	#end
#	#@radio.when_on(3) do 
#	#	@para.text = "yay"
#	#end
#	#text = para ""
#	#@target = text_button(:height => 50, :width => 100)
#	#@target.state.alerted do
#	#	text.replace(@target.state.value.to_s)
#	#end	
#	#rar = text_button(:height => 100, :width => 200, :toggle => false)
#	#compressor = shape_button do |part|
#	#	stack :width => 200, :height => 150 do
#	#		part['compressor'] = shape(:width => 200, :height => 150)do
#	#			nostroke
#	#			fill red
#	#			oval(:top => 50, :left => 25, :height => 75, :width => 25)
#	#			oval(:top => 50, :left => 150, :height => 75, :width => 25)
#	#			rect(:top => 49, :left => 38, :height => 76, :width => 125, :curve => 2)
#	#			rect(:top => 25, :left => 45, :height => 10, :width => 125, :curve => 2)
#	#			rect(:top => 21, :left => 36, :height => 16, :width => 32, :curve => 6)
#	#			rect(:top => 30, :left => 38, :height => 30, :width => 26)
#	#		end
#	#		part['caption'] = subtitle("OFF").style(:align => 'center', :top => 65, :stroke => white)
#	#	end
#	#end
#	#
#	#compressor.when_on do |part|
#	#	part['compressor'].style(:fill => green)
#	#	part['caption'].replace("ON")
#	#end
#	#compressor.when_off do |part|
#	#	part['compressor'].style(:fill => red)
#	#	part['caption'].replace("OFF")
#	#end
#    #
#	#compressor.state.alerted do |new|
#	#	text.replace(new)
#	#end
#end
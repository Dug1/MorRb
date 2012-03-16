class Fraction
	attr_reader :num, :den
	def initialize(num, den)
		@num = num
		@den = den
		reduce
	end
	
	def reduce
		factors = @den.prime_factors
		factors.each do |factor|
			if(@num%factor == 0)
				@num /= factor
				@den /= factor
			end
		end
	end
	
	def to_s 
		if(@den > 1)
			return "#{@num}/#{@den}"
		end
		return "#{@num}"
	end
	
	def to_f
		@num/@num
	end
	
	def +(fraction)
		@num = fraction.num*@den + @num*fraction.den
		@den = fraction.den*@den
		reduce
		self
	end
end

class Fixnum
	def prime_factors
		div_reflex(self, 2)
	end
	
	def div_reflex(current, divide_by)
		if(divide_by < current) 
			if(current%divide_by == 0) 
				return div_reflex(current/divide_by, divide_by) << divide_by 
			else 
				return div_reflex(current, divide_by + 1)
			end
		else
			return [divide_by]
		end
	end
end
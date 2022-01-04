# a = true

# if a
# 	puts 'It's true'
# end

def double_num(num)
	num * 2
end

def double_evens(arr)
	arr.map do |num|
		new_num = num.even? ? double_num(num) : num
	end
end

p double_evens([1, 2, 3, 4, 5])
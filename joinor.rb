def joinor(array, punctuation = {}, final_and = {})
	if punctuation.empty? && final_and.empty?
		"#{array[0..-2].join(',')} or #{array[-1]}" 
	elsif final_and.empty? 
		"#{array[0..-2].join(punctuation)} or #{array[-1]}"
	else
		"#{array[0..-2].join(punctuation)} #{final_and} #{array[-1]}"
	end
end
	
	
	
p joinor([1, 2])                   # => "1 or 2"
p joinor([1, 2, 3])                # => "1, 2, or 3"
p joinor([1, 2, 3], '; ')          # => "1; 2; or 3"
p joinor([1, 2, 3], ', ', 'and')   # => "1, 2, and 3"

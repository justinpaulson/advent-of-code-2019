nums = File.readlines(ARGV[0])[0].split('')

total= 0
neg_position = nil
nums.each_with_index do |num, i|
  num == "(" ? total += 1 : total -= 1
  if total < 0 && !neg_position
    neg_position = i + 1
  end
end

puts "Total: #{total}"
puts "Neg Position: #{neg_position}"

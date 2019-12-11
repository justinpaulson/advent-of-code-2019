inputs = File.readlines(ARGV[0]).map(&:to_i)

puts inputs.sum

total = 0

results = {}
i = 0
while true
  total += inputs[i]
  break if results[total]
  results[total] = 1
  i == inputs.length - 1 ? i = 0 : i += 1
end

puts total
# puts results.to_s



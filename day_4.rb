first_point = 125730
second_point = 579381

def passes_dup_test(num)
  nums = num.to_s.split('')
  smallest = nums[0]
  nums.drop(1).each do |n|
    return true if n == smallest
    smallest = n
  end
  false
end

def passes_seq_test(num)
  nums = num.to_s.split('')
  smallest = nums[0]
  nums.each do |n|
    return false unless n >= smallest
    smallest = n
  end
  true
end

def passes_tests_1(num)
  passes_dup_test(num) && passes_seq_test(num)
end

def passes_tests_2(num)
  nums = num.to_s.split('').map(&:to_i)
  buckets = []
  smallest = nums[0]
  nums.each do |n|
    return false unless n >= smallest

    buckets[n] ||= 0
    buckets[n] += 1
    smallest = n
  end
  buckets.each{|b| return true if b == 2}
  false
end

total_1 = 0
total_2 = 0
first_point.upto(second_point) do |i|
  total_1 += 1 if passes_tests_1(i)
  total_2 += 1 if passes_tests_2(i)
end

puts "Starting Point: " + first_point.to_s
puts "Ending Point: " + second_point.to_s
puts "Total codes for 1: " + total_1.to_s
puts "Total codes for 2: " + total_2.to_s

def fuel_needed(weight)
  (weight/3).floor > 2 ? (weight/3).floor - 2 : 0
end

def full_fuel_needed(weight)
  total_fuel = 0
  while (weight = fuel_needed(weight)) > 0
    total_fuel += weight
  end
  total_fuel
end

weights = []

File.open(ARGV[0]).each{|weight| weights << weight.to_i}

part_1_total = weights.sum{|weight| fuel_needed(weight)}

puts "Part 1 Requirement: " + part_1_total.to_s

part_2_total = weights.sum{|weight| full_fuel_needed(weight)}

puts "Part 2 Requirement: " + part_2_total.to_s

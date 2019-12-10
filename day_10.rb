asteroids = File.readlines(ARGV[0]).map{|input| input.strip.split('')}

def is_visible(location, target, locations)
  # puts locations.to_s
  x_diff = target[0] - location[0]
  y_diff = target[1] - location[1]
  g = gcd(y_diff.abs(), x_diff.abs())
  min_step_x = g == 0 ? x_diff : x_diff / g
  min_step_y = g == 0 ? y_diff : y_diff / g

  if location == [4,0]
    puts "Location: [4, 0]"
    puts "Target: #{target}"
    puts "GCD: #{g}"
    puts "Y Diff: #{y_diff}, Min Step Y: #{min_step_y}"
    puts "X Diff: #{x_diff}, Min Step X: #{min_step_x}"
    # puts "Step to: #{[(x_diff/min_step_x).abs() - 1, (y_diff/min_step_y).abs() - 1].max}"
  end
  last_stop = 0
  if min_step_x == 0
    last_stop = (y_diff/min_step_y).abs() - 1
  elsif min_step_y == 0
    last_stop = (x_diff/min_step_x).abs() - 1
  else
    last_stop = [(x_diff/min_step_x).abs() - 1, (y_diff/min_step_y).abs() - 1].max
  end
  1.upto(last_stop) do |offset|
    if location == [4,0]
      puts "checking " + [location[0] + (offset*min_step_x), location[1]+(offset * min_step_y)].to_s
      puts locations.include?([location[0] + (offset*min_step_x), location[1]+(offset * min_step_y)])
    end
    return false if locations.include?([location[0] + (offset*min_step_x), location[1]+(offset * min_step_y)])
  end
  true
end

def gcd(a, b)
  return b if a == 0
  return a if b == 0
  a = a.clone
  b = b.clone
  if a < b
    swap = b
    b = a
    a = swap
  end
  r = a % b
  if r == 0
    return b
  else
    return gcd(b, r)
  end
end

asteroid_locations = []

asteroids.each_with_index do |a_line, y|
  a_line.each_with_index do |items, x|
    asteroid_locations << [x,y] if items == '#'
  end
end

max = 0
max_location = []
asteroid_locations.each do |location|
  # puts "Testing: #{location}"
  total_visible = 0
  asteroid_locations.each do |target|
    next if location == target
    total_visible += 1 if is_visible(location, target, asteroid_locations)
  end
  # puts "Total visible for location #{total_visible}"
  if location == [3,6]
    puts "total_visible: #{total_visible}"
  end
  if max < total_visible
    max = total_visible
    max_location = location
  end
end

# puts "asteroids: " + asteroids.to_s
# puts "Asteroid locations: " + asteroid_locations.count.to_s
puts "Max locations: " + max.to_s
puts "Max location: " + max_location.to_s

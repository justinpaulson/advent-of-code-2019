asteroids = File.readlines(ARGV[0]).map{|input| input.strip.split('')}

def is_visible(location, target, locations)
  x_diff = target[0] - location[0]
  y_diff = target[1] - location[1]
  g = gcd(y_diff.abs(), x_diff.abs())
  g = g == 0 ? 1 : g
  min_step_x = x_diff / g
  min_step_y = y_diff / g
  1.upto(g-1) do |offset|
    return false if locations.include?([location[0] + (offset*min_step_x), location[1]+(offset * min_step_y)])
  end
  true
end

def gcd(a, b)
  return b if a == 0
  return a if b == 0
  a, b = b, a if a < b
  a % b == 0 ? b : gcd(b, a % b)
end

def visibles(location, locations)
  answer = []
  locations.select{|l| l != location}.each do |target|
    next if location == target
    angle = Math.atan2(target[1] - location[1], target[0] - location[0])
    answer << [target, angle] if is_visible(location, target, locations)
  end
  answer
end

def print_asteroids(asteroids, max_location, max)
  system 'clear'
  asteroids.each{|line| puts line.join('')}
  puts "Base Location: #{max_location}"
  puts "Max visible: #{max}"
  sleep 0.1
end

asteroid_locations = []
asteroids.each_with_index do |line, y|
  line.each_with_index do |item, x|
    asteroid_locations << [x,y] if item == '#'
  end
end

max = 0
max_location = []
asteroid_locations.each do |location|
  total_visible = 0
  asteroid_locations.each do |target|
    next if location == target
    total_visible += 1 if is_visible(location, target, asteroid_locations)
  end
  if max < total_visible
    max = total_visible
    max_location = location
  end
end

destroyed = 0
asteroid_200 = []
while (visibles = visibles(max_location, asteroid_locations)).count > 0
  quads = [
    visibles.select{|a| a[0][0] >= max_location[0] && a[1] <= 0},
    visibles.select{|a| a[0][0] >= max_location[0] && a[1] > 0},
    visibles.select{|a| a[0][0] < max_location[0] && a[1] >= 0},
    visibles.select{|a| a[0][0] < max_location[0] && a[1] < 0}
  ]

  quads.each do |quad|
    quad.sort_by{|a| a[1]}.each do |a|
      asteroid_locations = asteroid_locations.select{|l| l != a[0]}
      asteroids[a[0][1]][a[0][0]] = '.'
      print_asteroids(asteroids, max_location, max)
      destroyed += 1
      if destroyed == 200
        asteroid_200 = [a[0][0],a[0][1]]
      end
    end
  end
end

puts "200th Asteroid Deleted: #{asteroid_200}"
puts "Answer: #{asteroid_200[0] * 100 + asteroid_200[1]}"

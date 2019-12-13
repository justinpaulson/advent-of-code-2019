moons = File.readlines(ARGV[0]).map{|input| input.split(?,).map(&:to_i)}

def move_axis(moons, velocities)
  moons.each_with_index do |moon, i|
    moons.each do |target|
      if moon < target
        velocities[i] += 1
      elsif moon > target
        velocities[i] -= 1
      end
    end
  end

  moons = moons.map.with_index do |moon, i|
    velocity = velocities[i]
    moon+= velocity
  end
  [moons, velocities]
end

def energy(moon)
  sum = 0
  0.upto(2) do |cord|
    sum += moon[cord].abs()
  end
  sum
end

def equal_states(state_1, state_2)
  0.upto(3) do |index|
    return false if state_1[index] != state_2[index]
  end
  true
end

#=============================
#Part 1
#=============================
velocities = [[0,0,0],[0,0,0],[0,0,0],[0,0,0]]
steps = 1000
0.upto(2) do |axis|
  moons_for_axis = [moons[0][axis],moons[1][axis],moons[2][axis],moons[3][axis]]
  velocities_for_axis = [0,0,0,0]
  1.upto(steps) do |step|
    moons_for_axis, velocities_for_axis = move_axis(moons_for_axis, velocities_for_axis)
  end
  moons_for_axis.each_with_index do |moon, i|
    moons[i][axis] = moon
  end
  velocities_for_axis.each_with_index do |velocity, i|
    velocities[i][axis] = velocity
  end
end

puts "Total Energy after 1000 steps: " + moons.map.with_index{|m,i| energy(m) * energy(velocities[i])}.sum.to_s

##================================
# Part 2
##================================
def gcd(a, b)
  return b if a == 0
  return a if b == 0
  a, b = b, a if a < b
  a % b == 0 ? b : gcd(b, a % b)
end

def lcm(a,b)
  a * b / gcd(a,b)
end

moons = File.readlines(ARGV[0]).map{|input| input.split(?,).map(&:to_i)}
cycles = []
0.upto(2) do |axis|
  moons_for_axis = [moons[0][axis],moons[1][axis],moons[2][axis],moons[3][axis]]
  initial_state = moons_for_axis.map{|m| m.clone}
  velocities = [0,0,0,0]
  step = 0
  while true
    step += 1
    moons_for_axis, velocities = move_axis(moons_for_axis, velocities)
    if equal_states(initial_state, moons_for_axis)
      cycles[axis] = step + 1
      break
    end
  end
end

puts "The cycles [x, y, z]: " + cycles.to_s

puts "Common Cycle Occurs at: " + lcm(lcm(cycles[0], cycles[1]), cycles[2]).to_s

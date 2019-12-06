inputs = File.readlines(ARGV[0]).map{|input| input.split(?)).map(&:strip)}

planets = {}

inputs.each{|o| planets[o[1]] = o[0]}

orbits = 0

planets.each do |planet, upline|
  while !upline.nil?
    upline = planets[upline]
    orbits += 1
  end
end

puts orbits

def san_in_downlines?(start, planets)
  planet = planets["SAN"]
  @total = 0
  while !planet.nil?
    return true if planet == start
    planet = planets[planet]
    @total += 1
  end
  return false
end

jumps = 0

upline = planets['YOU']

while upline != "SAN"
  upline = planets[upline]
  jumps += 1
  if san_in_downlines?(upline, planets)
    jumps += @total
    break
  end
end

puts jumps
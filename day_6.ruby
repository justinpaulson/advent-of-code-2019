planets = {}
inputs = File.readlines(ARGV[0]).map{|input| input.split(?)).map(&:strip)}.each{|o| planets[o[1]] = o[0]}
orbits = 0

planets.each do |planet, upline|
  while !upline.nil?
    upline = planets[upline]
    orbits += 1
  end
end

puts "Total Direct and Indiret Orbits: " + orbits.to_s

def san_in_downlines?(start, planets)
  planet = planets["SAN"]
  @total = 0
  while !planet.nil?
    return true if planet == start
    planet = planets[planet]
    @total += 1
  end
  false
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

puts "Total jumps from YOU to SAN: " + jumps.to_s
load "int_code.rb"
code = File.read(ARGV[0]).split(?,).map(&:to_i)

def check_point(code, x, y)
  catcher = IntcodeCatcher.new
  computer = IntCode.new(code.clone, [y, x], false, catcher)
  computer.run
  output = catcher.outputs.shift
  case output
  when 0
    return '.'
  when 1
    return '#'
  end
end

total = 0
0.upto(49) do |x|
  0.upto(49) do |y|
    total += 1 if check_point(code, x, y) == '#'
  end
end
puts "Total affected area: #{total}"

x = 0
y = 100
while true
  case check_point(code, x, y)
  when '.'
    x += 1
  when '#'
    if check_point(code, x + 99, y - 99) == '#'
      break
    else
      y +=1
    end
  end
end
puts "Position of ship in beam: #{((x) * 10000 + (y-99))}"

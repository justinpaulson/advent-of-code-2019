load "int_code.rb"
code = File.read(ARGV[0]).split(?,).map(&:to_i)

def check_point(code, x, y)
  catcher = IntcodeCatcher.new
  IntCode.new(code.clone, [y, x], false, catcher).run
  catcher.outputs.shift == 0 ? '.' : '#'
end

puts "Total affected area: #{0.upto(49).inject(0){|i, x| i + 0.upto(49).inject(0){|j, y| j + (check_point(code, x, y) == '#' ? 1 : 0)}}}"

while true
  if check_point(code, x ||= 0, y ||= 100) == '#' && check_point(code, x + 99, y - 99) == '#'
    puts "Position of ship in beam: #{((x) * 10000 + (y-99))}"
    break
  end
  check_point(code, x, y) == '.' ? x+=1 : y+=1
end

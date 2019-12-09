load 'int_code.rb'
code = File.read(ARGV[0]).split(?,).map(&:to_i)

puts "Part 1: "
IntCode.new(code, [1]).run
puts "Part 2: "
IntCode.new(code, [2]).run

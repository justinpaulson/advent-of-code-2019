load "int_code.rb"
code = File.read("day_25_input").split(?,).map(&:to_i)

catcher = IntcodeCatcher.new

computer = IntCode.new(code.clone, [], false, catcher)
computer.run

while true
  line = ""
  while output = catcher.outputs.shift
    line += output.chr
  end

  puts line
  computer.add_input(gets().split('\n')[0])
  computer.run
end


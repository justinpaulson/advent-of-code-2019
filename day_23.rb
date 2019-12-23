load "int_code.rb"
code = File.read(ARGV[0]).split(?,).map(&:to_i)
catchers = Array.new(50, IntcodeCatcher.new)
computers = []
0.upto(49){|i| computers << IntCode.new(code.clone, [i, -1], false, catchers[i]) }
nat = IntcodeCatcher.new

computers.map(&:run)

answer = 0
while true
  catchers.each do |catcher|
    target, x, y = catcher.outputs.shift(3)
    (target != 255 ? computers[target].add_input([x,y]) : nat.add_input([x, y])) if target
  end
  if !computers.any?{|computer| computer.inputs.length > 1}
    while nat.outputs.length > 1
      x, y = nat.outputs.shift(2)
    end
    break if y == answer
    answer = y
    computers[0].add_input([x,y])
    puts "Heat warning received: #{answer}"
  end
  computers.map(&:run)
end
puts "The following warning was received twice in a row: #{answer}"

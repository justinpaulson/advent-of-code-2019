load "int_code.rb"
code = File.read(ARGV[0]).split(?,).map(&:to_i)

catchers = []
0.upto(49){|_| catchers << IntcodeCatcher.new}

computers = []
0.upto(49){|i| computers << IntCode.new(code.clone, [i, -1, -1, -1], false, catchers[i]) }

computers.map(&:run)
nat = IntcodeCatcher.new

target = 0
answer = 0
x = 0
y = 0
while true
  catchers.each do |catcher|
    while output = catcher.outputs.shift
      target = output
      x = catcher.outputs.shift
      y = catcher.outputs.shift
      if target < 50
        computers[target].add_input([x,y])
      end
      if target == 255
        nat.add_input(x)
        nat.add_input(y)
      end
    end
  end

  computers.each{|comp| comp.add_input(-1) if comp.inputs.length < 1 }


  idle = true
  computers.each_with_index do |computer, i|
    if computer.inputs.length > 1
      idle = false
    end
  end

  if idle
    while check = nat.outputs.shift
      x = check
      y = nat.outputs.shift
    end
    break if y == answer
    computers[0].add_input([x,y])

    answer = y
    puts "Heat warning received: #{answer}"
  end
  computers.map(&:run)
end

puts "The following warning was received twice in a row: #{answer}"

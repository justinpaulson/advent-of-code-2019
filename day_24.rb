inputs = File.readlines(ARGV[0])

def print_grid(grid, with_z = false)
  0.upto(4) do |y|
    line = ''
    0.upto(4) do |x|
      if with_z
        line += grid[[x,y,0]] || ' '
      else
        line += grid[[x,y]] || ' '
      end
    end
    puts line
  end
end

chart = {}

inputs.each_with_index do |line, y|
  line.split('').each_with_index do |input, x|
    chart[[x,y]] = input
  end
end

def same_layout(l1, l2)
  0.upto(4) do |x|
    0.upto(4) do |y|
      return false unless l1[[x,y]] == l2[[x,y]]
    end
  end
  true
end

new_grid = {}

layouts = []

while !layouts.any?{|l| same_layout(l, new_grid)}
  layouts << new_grid.clone
  0.upto(4) do |x|
    0.upto(4) do |y|
      if chart[[x,y+1]] == '#' && chart[[x-1,y]] != '#' && chart[[x+1,y]] != '#' && chart[[x,y-1]] != '#'
        new_grid[[x,y]] = '#'
      elsif chart[[x,y+1]] != '#' && chart[[x-1,y]] == '#' && chart[[x+1,y]] != '#' && chart[[x,y-1]] != '#'
        new_grid[[x,y]] = '#'
      elsif chart[[x,y+1]] != '#' && chart[[x-1,y]] != '#' && chart[[x+1,y]] == '#' && chart[[x,y-1]] != '#'
        new_grid[[x,y]] = '#'
      elsif chart[[x,y+1]] != '#' && chart[[x-1,y]] != '#' && chart[[x+1,y]] != '#' && chart[[x,y-1]] == '#'
        new_grid[[x,y]] = '#'
      elsif chart[[x,y]] == '.'
        if chart[[x,y+1]] == '#' && chart[[x-1,y]] == '#' && chart[[x+1,y]] != '#' && chart[[x,y-1]] != '#'
          new_grid[[x,y]] = '#'
        elsif chart[[x,y+1]] == '#' && chart[[x-1,y]] != '#' && chart[[x+1,y]] == '#' && chart[[x,y-1]] != '#'
          new_grid[[x,y]] = '#'
        elsif chart[[x,y+1]] == '#' && chart[[x-1,y]] != '#' && chart[[x+1,y]] != '#' && chart[[x,y-1]] == '#'
          new_grid[[x,y]] = '#'
        elsif chart[[x,y+1]] != '#' && chart[[x-1,y]] == '#' && chart[[x+1,y]] == '#' && chart[[x,y-1]] != '#'
          new_grid[[x,y,]] = '#'
        elsif chart[[x,y+1]] != '#' && chart[[x-1,y]] == '#' && chart[[x+1,y]] != '#' && chart[[x,y-1]] == '#'
          new_grid[[x,y,]] = '#'
        elsif chart[[x,y+1]] != '#' && chart[[x-1,y]] != '#' && chart[[x+1,y]] == '#' && chart[[x,y-1]] == '#'
          new_grid[[x,y,]] = '#'
        else
          new_grid[[x,y]] = '.'
        end
      else
        new_grid[[x,y]] = '.'
      end
    end
  end
  chart = new_grid.clone
end

total = 0
0.upto(25) do |power|
  if new_grid[[power % 5, power / 5]] == '#'
    total += 2 ** power
  end
end

print_grid(new_grid)

puts "Biodiversity Rating: #{total}"


-100.upto(100) do |z|
  0.upto(4) do |x|
   0.upto(4) do |y|
    chart[[x,y,z]] = '.'
   end
  end
end

inputs.each_with_index do |line, y|
  line.split('').each_with_index do |input, x|
    chart[[x,y,0]] = input
  end
end

chart[[2,2,0]] = '?'

def adjacent_bugs(chart, location)
  bugs = 0
  x = location[0]
  y = location[1]
  z = location[2]
  if [[1,1],[3,1],[1,3],[3,3]].include?([x,y])
    if chart[[x+1,y,z]] == '#'
      bugs += 1
    end
    if chart[[x-1,y,z]] == '#'
      bugs += 1
    end
    if chart[[x,y+1,z]] == '#'
      bugs += 1
    end
    if chart[[x,y-1,z]] == '#'
      bugs += 1
    end
  elsif [2,1] == [x,y]
    if chart[[x+1,y,z]] == '#'
      bugs += 1
    end
    if chart[[x-1,y,z]] == '#'
      bugs += 1
    end
    if chart[[x,y-1,z]] == '#'
      bugs += 1
    end
    if chart[[0,0,z+1]] == '#'
      bugs += 1
    end
    if chart[[1,0,z+1]] == '#'
      bugs += 1
    end
    if chart[[2,0,z+1]] == '#'
      bugs += 1
    end
    if chart[[3,0,z+1]] == '#'
      bugs += 1
    end
    if chart[[4,0,z+1]] == '#'
      bugs += 1
    end
  elsif [1,2] == [x,y]
    if chart[[x-1,y,z]] == '#'
      bugs += 1
    end
    if chart[[x,y+1,z]] == '#'
      bugs += 1
    end
    if chart[[x,y-1,z]] == '#'
      bugs += 1
    end
    if chart[[0,0,z+1]] == '#'
      bugs += 1
    end
    if chart[[0,1,z+1]] == '#'
      bugs += 1
    end
    if chart[[0,2,z+1]] == '#'
      bugs += 1
    end
    if chart[[0,3,z+1]] == '#'
      bugs += 1
    end
    if chart[[0,4,z+1]] == '#'
      bugs += 1
    end
  elsif [2,3] == [x,y]
    if chart[[x+1,y,z]] == '#'
      bugs += 1
    end
    if chart[[x-1,y,z]] == '#'
      bugs += 1
    end
    if chart[[x,y+1,z]] == '#'
      bugs += 1
    end
    if chart[[0,4,z+1]] == '#'
      bugs += 1
    end
    if chart[[1,4,z+1]] == '#'
      bugs += 1
    end
    if chart[[2,4,z+1]] == '#'
      bugs += 1
    end
    if chart[[3,4,z+1]] == '#'
      bugs += 1
    end
    if chart[[4,4,z+1]] == '#'
      bugs += 1
    end
  elsif [3,2] == [x,y]
    if chart[[x+1,y,z]] == '#'
      bugs += 1
    end
    if chart[[x,y+1,z]] == '#'
      bugs += 1
    end
    if chart[[x,y-1,z]] == '#'
      bugs += 1
    end
    if chart[[4,0,z+1]] == '#'
      bugs += 1
    end
    if chart[[4,1,z+1]] == '#'
      bugs += 1
    end
    if chart[[4,2,z+1]] == '#'
      bugs += 1
    end
    if chart[[4,3,z+1]] == '#'
      bugs += 1
    end
    if chart[[4,4,z+1]] == '#'
      bugs += 1
    end
  else
    case y
    when 0
      if chart[[x,y+1,z]] == '#'
        bugs += 1
      end
      if chart[[2,1,z-1]] == '#'
        bugs += 1
      end
    when 1,2,3
      if chart[[x,y-1,z]] == '#'
        bugs += 1
      end
      if chart[[x,y+1,z]] == '#'
        bugs += 1
      end
    when 4
      if chart[[x,y-1,z]] == '#'
        bugs += 1
      end
      if chart[[2,3,z-1]] == '#'
        bugs += 1
      end
    end
    case x
    when 0
      if chart[[x+1,y,z]] == '#'
        bugs += 1
      end
      if chart[[1,2,z-1]] == '#'
        bugs += 1
      end
    when 1,2,3
      if chart[[x-1,y,z]] == '#'
        bugs += 1
      end
      if chart[[x+1,y,z]] == '#'
        bugs += 1
      end
    when 4
      if chart[[x-1,y,z]] == '#'
        bugs += 1
      end
      if chart[[3,2,z-1]] == '#'
        bugs += 1
      end
    end
  end
  bugs
end

new_grid = {}
new_grid[[2,2,0]] = '?'
1.upto(200) do |s|
  0.upto(4) do |x|
    0.upto(4) do |y|
      -100.upto(100) do |z|
        next if [x,y] == [2,2]
        adj_bugs = adjacent_bugs(chart, [x,y,z])
        if adj_bugs == 1 || (adj_bugs == 2 && chart[[x,y,z]] == '.')
          new_grid[[x,y,z]] = '#'
        else
          new_grid[[x,y,z]] = '.'
        end
      end
    end
  end
  chart = new_grid.clone
end

total = 0
0.upto(4) do |x|
  0.upto(4) do |y|
    -100.upto(100) do |z|
      total += 1 if new_grid[[x,y,z]] == '#'
    end
  end
end

print_grid(new_grid, true)
puts "Total Bugs: #{total}"


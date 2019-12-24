inputs = File.readlines(ARGV[0])

def print_grid(grid, z = false)
  0.upto(4) do |y|
    line = ''
    0.upto(4) do |x|
      if z
        line += grid[[x,y,0]] || ' '
      else
        line += grid[[x,y]] || ' '
      end
    end
    puts line
  end
end

def adjacent_bugs_flat(chart, location)
  x, y = location
  [[x+1,y],[x-1,y],[x,y+1],[x,y-1]].inject(0){|i, cell| i + (chart[cell] == '#' ? 1 : 0)}
end

def same_layout(l1, l2)
  0.upto(4) do |x|
    0.upto(4) do |y|
      return false unless l1[[x,y]] == l2[[x,y]]
    end
  end
  true
end

chart = {}
inputs.each_with_index do |line, y|
  line.split('').each_with_index do |input, x|
    chart[[x,y]] = input
  end
end

new_grid = {}
layouts = []
while !layouts.any?{|l| same_layout(l, new_grid)}
  layouts << new_grid.clone
  0.upto(4) do |x|
    0.upto(4) do |y|
      bugs = adjacent_bugs_flat(chart, [x,y])
      if bugs == 1 || (bugs == 2 && chart[[x,y]] == '.')
        new_grid[[x,y]] = '#'
      else
        new_grid[[x,y]] = '.'
      end
    end
  end
  chart = new_grid.clone
end

print_grid(new_grid)
puts "Biodiversity Rating: #{0.upto(24).inject(0){|i, power| new_grid[[power % 5, power / 5]] == '#' ? i + 2 ** power : i}}"

inputs.each_with_index do |line, y|
  line.split('').each_with_index do |input, x|
    chart[[x,y,0]] = input
  end
end

chart[[2,2,0]] = '?'

def adjacent_bugs(chart, location)
  bugs = 0
  x, y, z = location
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
1.upto(200) do |_|
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

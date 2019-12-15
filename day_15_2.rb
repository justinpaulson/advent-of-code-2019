# Uses the grid output from part 1 as a input

gridlines = File.readlines(ARGV[0])

grid = {}

0.upto(40) do |x|
  0.upto(40) do |y|
    grid[[x,y]] = gridlines[y][x]
  end
end

def print_grid(grid)
  system 'clear'
  0.upto(40) do |y|
    line = ''
    0.upto(60) do |x|
      line += grid[[x,y]] || ' '
    end
    puts line
  end
end

def still_space(grid)
  0.upto(40) do |x|
    0.upto(40) do |y|
      return true if grid[[x,y]] == '.'
    end
  end
  false
end

def spread_oxygen(grid)
  new_grid = {}
  grid.each do |k,v|
    new_grid[k] = v
  end
  0.upto(40) do |x|
    0.upto(40) do |y|
      if grid[[x,y]] == 'O'
        [[x+1,y],[x-1,y],[x,y+1],[x,y-1]].each do |coord|
          new_grid[coord] = 'O' if new_grid[coord] == '.'
        end
      end
    end
  end
  new_grid
end

minutes = 0
while still_space(grid)
  minutes += 1

  grid = spread_oxygen(grid)

  print_grid(grid)
  puts "Total minutes: #{minutes}"
  sleep 0.001
end

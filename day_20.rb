map_input = File.readlines(ARGV[0]).map{|m| m.split('')}

first = 2
second = 32
third_x = 90
third_y = third_x
fourth_x = 120
fourth_y = fourth_x
# second = 6
# third_x = 14
# fourth_x =18
# third_y = 12
# fourth_y = 16
# second = 8
# third_x = 26
# fourth_x =32
# third_y = 28
# fourth_y = 34

def print_grid(grid)
  system 'clear'
  0.upto(122) do |y|
    line = ''
    0.upto(122) do |x|
      line += grid[[x,y]] || ' '
    end
    puts line
  end
end

grid = {}
map_input.each_with_index do |line, y|
  line.each_with_index do |pixel, x|
    grid[[x,y]] = pixel
  end
end

start = []
finish = []
portals = {}

0.upto(123) do |x|
  if /[[:upper:]]/.match(grid[[x,first - 2]]) &&
      /[[:upper:]]/.match(grid[[x,first - 1]]) &&
      !['AA','ZZ'].include?("#{grid[[x,first - 2]]}#{grid[[x,first - 1]]}")
    portals[[x,first]] = "#{grid[[x,first - 2]]}#{grid[[x,first - 1]]}"
  elsif "#{grid[[x,first - 2]]}#{grid[[x,first - 1]]}" == 'AA'
    start = [x,first]
  elsif "#{grid[[x,first - 2]]}#{grid[[x,first - 1]]}" == 'ZZ'
    finish = [x,first]
  end
  if /[[:upper:]]/.match(grid[[x,second + 1]]) &&
      /[[:upper:]]/.match(grid[[x,second + 2]]) &&
      !['AA','ZZ'].include?("#{grid[[x,second + 1]]}#{grid[[x,second + 2]]}")
    portals[[x,second]] = "#{grid[[x,second + 1]]}#{grid[[x,second + 2]]}"
  elsif "#{grid[[x,second + 1]]}#{grid[[x,second + 2]]}" == 'AA'
    start = [x,second]
  elsif "#{grid[[x,second + 1]]}#{grid[[x,second + 2]]}" == 'ZZ'
    finish = [x,second]
  end
  if /[[:upper:]]/.match(grid[[x,third_y - 2]]) &&
      /[[:upper:]]/.match(grid[[x,third_y - 1]]) &&
      !['AA','ZZ'].include?("#{grid[[x,third_y - 2]]}#{grid[[x,third_y - 1]]}")
    portals[[x,third_y]] = "#{grid[[x,third_y - 2]]}#{grid[[x,third_y - 1]]}"
  elsif "#{grid[[x,third_y - 2]]}#{grid[[x,third_y - 1]]}" == 'AA'
    start = [x,third_y]
  elsif "#{grid[[x,third_y - 2]]}#{grid[[x,third_y - 1]]}" == 'ZZ'
    finish = [x,third_y]
  end
  if /[[:upper:]]/.match(grid[[x,fourth_y + 1]]) &&
      /[[:upper:]]/.match(grid[[x,fourth_y + 2]]) &&
      !['AA','ZZ'].include?("#{grid[[x,fourth_y + 1]]}#{grid[[x,fourth_y + 2]]}")
    portals[[x,fourth_y]] = "#{grid[[x,fourth_y + 1]]}#{grid[[x,fourth_y + 2]]}"
  elsif "#{grid[[x,fourth_y + 1]]}#{grid[[x,fourth_y + 2]]}" == 'AA'
    start = [x,fourth_y]
  elsif "#{grid[[x,fourth_y + 1]]}#{grid[[x,fourth_y + 2]]}" == 'ZZ'
    finish = [x,fourth_y]
  end
end

0.upto(123) do |y|
  if /[[:upper:]]/.match(grid[[first - 2,y]]) &&
      /[[:upper:]]/.match(grid[[first - 1,y]]) &&
      !['AA','ZZ'].include?("#{grid[[first - 2,y]]}#{grid[[first - 1,y]]}")
    portals[[first,y]] = "#{grid[[first - 2,y]]}#{grid[[first - 1,y]]}"
  elsif "#{grid[[first - 2,y]]}#{grid[[first - 1,y]]}" == 'AA'
    start = [first, y]
  elsif "#{grid[[first - 2,y]]}#{grid[[first - 1,y]]}" == 'ZZ'
    finish = [first, y]
  end
  if /[[:upper:]]/.match(grid[[second + 1,y]]) &&
      /[[:upper:]]/.match(grid[[second + 2,y]]) &&
      !['AA','ZZ'].include?("#{grid[[second + 1, y]]}#{grid[[second + 2, y]]}")
    portals[[second,y]] = "#{grid[[second + 1,y]]}#{grid[[second + 2,y]]}"
  elsif "#{grid[[second + 1, y]]}#{grid[[second + 2, y]]}" == 'AA'
    start = [second, y]
  elsif "#{grid[[second + 1, y]]}#{grid[[second + 2, y]]}" == 'ZZ'
    finish = [second, y]
  end
  if /[[:upper:]]/.match(grid[[third_x - 2,y]]) &&
      /[[:upper:]]/.match(grid[[third_x - 1,y]]) &&
      !['AA','ZZ'].include?("#{grid[[third_x - 2, y]]}#{grid[[third_x - 1, y]]}")
    portals[[third_x,y]] = "#{grid[[third_x - 2,y]]}#{grid[[third_x - 1,y]]}"
  elsif "#{grid[[third_x - 2, y]]}#{grid[[third_x - 1, y]]}" == 'AA'
    start = [third_x, y]
  elsif "#{grid[[third_x - 2, y]]}#{grid[[third_x - 1, y]]}" == 'ZZ'
    finish = [third_x, y]
  end
  if /[[:upper:]]/.match(grid[[fourth_x + 1,y]]) &&
      /[[:upper:]]/.match(grid[[fourth_x + 2,y]]) &&
      !['AA','ZZ'].include?("#{grid[[fourth_x + 1, y]]}#{grid[[fourth_x + 2, y]]}")
    portals[[fourth_x,y]] = "#{grid[[fourth_x + 1,y]]}#{grid[[fourth_x + 2,y]]}"
  elsif "#{grid[[fourth_x + 1, y]]}#{grid[[fourth_x + 2, y]]}" == 'AA'
    start = [fourth_x, y]
  elsif "#{grid[[fourth_x + 1, y]]}#{grid[[fourth_x + 2, y]]}" == 'ZZ'
    finish = [fourth_x, y]
  end
end

puts portals.to_s

cursor = start
path = []
direction = 'v'
grid[cursor] = direction
while cursor != finish
  grid[cursor] = '.'
  if portals.keys.include?(cursor)
    portal = portals[cursor]
    if path[-2] == portals.select{|k,v| v == portal && k != cursor}.keys.first
      path.pop
    else
      path << cursor unless path.last == cursor
    end
    cursor = portals.select{|k,v| v == portal && k != cursor}.keys.first
    case cursor[0]
    when first, third_x
      direction = '>'
    when second, fourth_x
      direction = '<'
    end
    case cursor[1]
    when first, third_y
      direction = 'v'
    when second, fourth_y
      direction = '^'
    end
  end
  case direction
  when '^'
    if grid[[cursor[0]+1,cursor[1]]] == '#'
      if grid[[cursor[0], cursor[1]-1]] == '#'
        if grid[[cursor[0]-1, cursor[1]]] == '#'
          cursor = [cursor[0], cursor[1]+1]
          direction = 'v'
        else
          if path[-2] == [cursor[0]-1, cursor[1]]
            path.pop
          else
            path << cursor unless path.last == cursor
          end
          cursor = [cursor[0]-1, cursor[1]]
          direction = '<'
        end
      else
        if path[-2] == [cursor[0], cursor[1]-1]
          path.pop
        else
          path << cursor unless path.last == cursor
        end
        if path.include?([cursor[0], cursor[1]-1]) && path[-1] != [cursor[0], cursor[1]-1]
          direction = 'v'
        else
          cursor = [cursor[0], cursor[1]-1]
        end
      end
    else
      if path[-2] == [cursor[0]+1, cursor[1]]
        path.pop
      else
        path << cursor unless path.last == cursor
      end
      cursor = [cursor[0]+1, cursor[1]]
      direction = '>'
    end
  when 'v'
    if grid[[cursor[0]-1,cursor[1]]] == '#'
      if grid[[cursor[0], cursor[1]+1]] == '#'
        if grid[[cursor[0]+1, cursor[1]]] == '#'
          cursor = [cursor[0], cursor[1]-1]
          direction = '^'
        else
          if path[-2] == [cursor[0]+1, cursor[1]]
            path.pop
          else
            path << cursor unless path.last == cursor
          end
          cursor = [cursor[0]+1, cursor[1]]
          direction = '>'
        end
      else
        if path[-2] == [cursor[0], cursor[1]+1]
          path.pop
        else
          path << cursor unless path.last == cursor
        end
        if path.include?([cursor[0], cursor[1]+1]) && path[-1] != [cursor[0], cursor[1]+1]
          direction = '^'
        else
          cursor = [cursor[0], cursor[1]+1]
        end
      end
    else
      if path[-2] == [cursor[0]-1, cursor[1]]
        path.pop
      else
        path << cursor unless path.last == cursor
      end
      cursor = [cursor[0]-1, cursor[1]]
      direction = '<'
    end
  when '<'
    if grid[[cursor[0],cursor[1]-1]] == '#'
      if grid[[cursor[0]-1, cursor[1]]] == '#'
        if grid[[cursor[0], cursor[1]+1]] == '#'
          cursor = [cursor[0]+1, cursor[1]]
          direction = '>'
        else
          if path[-2] == [cursor[0], cursor[1]+1]
            path.pop
          else
            path << cursor unless path.last == cursor
          end
          cursor = [cursor[0], cursor[1]+1]
          direction = 'v'
        end
      else
        if path[-2] == [cursor[0]-1, cursor[1]]
          path.pop
        else
          path << cursor unless path.last == cursor
        end
        if path.include?([cursor[0]-1, cursor[1]]) && path[-1] != [cursor[0]-1, cursor[1]]
          direction = '>'
        else
          cursor = [cursor[0]-1, cursor[1]]
        end
      end
    else
      if path[-2] == [cursor[0], cursor[1]-1]
        path.pop
      else
        path << cursor unless path.last == cursor
      end
      cursor = [cursor[0], cursor[1]-1]
      direction = '^'
    end
  when '>'
    if grid[[cursor[0], cursor[1]+1]] == '#'
      if grid[[cursor[0]+1, cursor[1]]] == '#'
        if grid[[cursor[0],cursor[1]-1]] == '#'
          cursor = [cursor[0]-1, cursor[1]]
          direction = '<'
        else
          if path[-2] == [cursor[0], cursor[1]-1]
            path.pop
          else
            path << cursor unless path.last == cursor
          end
          cursor = [cursor[0], cursor[1]-1]
          direction = '^'
        end
      else
        if path[-2] == [cursor[0]+1, cursor[1]]
          path.pop
        else
          path << cursor unless path.last == cursor
        end
        if path.include?([cursor[0]+1, cursor[1]]) && path[-1] != [cursor[0]+1, cursor[1]]
          direction = '<'
        else
          cursor = [cursor[0]+1, cursor[1]]
        end
      end
    else
      if path[-2] == [cursor[0], cursor[1]+1]
        path.pop
      else
        path << cursor unless path.last == cursor
      end
      cursor = [cursor[0], cursor[1]+1]
      direction = 'v'
    end
  end
  grid[cursor] = direction
  # print_grid(grid)
  # puts path.to_s
  # puts "Path Length: #{path.count}"
  # puts "Start: #{start}"
  # puts "Finish: #{finish}"
  # puts "Cursor: #{cursor}"
  # sleep 0.1
end

print_grid(grid)
puts path.to_s
puts "Path Length: #{path.count}"

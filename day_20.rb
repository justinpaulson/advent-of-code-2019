map_input = File.readlines(ARGV[0]).map{|m| m.split('')}

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

start = [51, 2]
finish = [120, 43]

cursor = start

path = []
direction = 'v'
grid[cursor] = direction
while cursor != finish
  grid[cursor] = '.'
  case direction
  when '^'
    if grid[[cursor[0]+1,cursor[1]]] == '#'
      if grid[[cursor[0], cursor[1]-1]] == '#'
        if grid[[cursor[0]-1, cursor[1]]] == '#'
          cursor = [cursor[0], cursor[1]+1]
          direction = 'v'
        else
          path << cursor
          cursor = [cursor[0]-1, cursor[1]]
          direction = '<'
        end
      else
        if path.last == cursor
          path.pop
        else
          path << cursor
        end
        cursor = [cursor[0], cursor[1]-1]
      end
    else
      path << cursor
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
          path << cursor
          cursor = [cursor[0]+1, cursor[1]]
          direction = '>'
        end
      else
        if path.last == cursor
          path.pop
        else
          path << cursor
        end
        cursor = [cursor[0], cursor[1]+1]
      end
    else
      path << cursor
      cursor = [cursor[0]-1, cursor[1]]
      direction = '<'
    end
  # when '<'
  #   if grid[[cursor[0],cursor[1]-1]] == '#'
  #     if grid[[cursor[0]-1, cursor[1]]] == '#'
  #       if grid[[cursor[0], cursor[1]+1]] == '#'
  #         cursor = [cursor[0]+1, cursor[1]]
  #         direction = '>'
  #       else
  #         path << cursor
  #         cursor = [cursor[0], cursor[1]+1]
  #         direction = 'v'
  #       end
  #     else
  #       if path.last == cursor
  #         path.pop
  #       else
  #         path << cursor
  #       end
  #       cursor = [cursor[0]-1, cursor[1]]
  #     end
  #   else
  #     path << cursor
  #     cursor = [cursor[0], cursor[1]-1]
  #     direction = '^'
  #   end
  # when '>'
  #   if grid[[cursor[0], cursor[1]+1]] == '#'
  #     if grid[[cursor[0]+1, cursor[1]]] == '#'
  #       if grid[[cursor[0],cursor[1]-1]] == '#'
  #         cursor = [cursor[0]-1, cursor[1]]
  #         direction = '<'
  #       else
  #         path << cursor
  #         cursor = [cursor[0], cursor[1]-1]
  #         direction = '^'
  #       end
  #     else
  #       if path.last == cursor
  #         path.pop
  #       else
  #         path << cursor
  #       end
  #       cursor = [cursor[0]+1, cursor[1]]
  #     end
  #   else
  #     path << cursor
  #     cursor = [cursor[0], cursor[1]+1]
  #     direction = 'v'
  #   end
  end
  grid[cursor] = direction
  print_grid(grid)
  sleep 0.01
end

puts path.to_s
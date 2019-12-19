map = File.readlines(ARGV[0]).map{|m| m.split('')}

def print_grid(grid)
  system 'clear'
  0.upto(9) do |y|
    line = ''
    0.upto(25) do |x|
      line += grid[[x,y]] || ' '
    end
    puts line
  end
end

def get_values(array)
  array.map{|a| a.values.first}
end

def remove_door(doors, value)
  key = []
  doors = doors.select do |k| 
    if k.keys.first == value
      key = k[value]
      false
    else
      true
    end
  end
  return doors, key
end


board = {}

keys = []
doors = []
cursor = []

def distance(board, keys, doors, cursor, key)
  distance = []
  path = []
  direction = '^'
  keys_ret = []
  while cursor[0] != key[0] || cursor[1] != key[1]
    pos = cursor.clone
    board[cursor] = '.'
    case direction
    when '^'
      if board[[cursor[0]+1,cursor[1]]] == '#' || get_values(doors).include?([cursor[0]+1,cursor[1]])
        if board[[cursor[0], cursor[1]-1]] == '#' || get_values(doors).include?([cursor[0],cursor[1]-1])
          if board[[cursor[0]-1, cursor[1]]] == '#' || get_values(doors).include?([cursor[0]-1,cursor[1]])
            cursor = [cursor[0], cursor[1]+1]
            direction = 'v'
          else
            cursor = [cursor[0]-1, cursor[1]]
            direction = '<'
          end
        else
          cursor = [cursor[0], cursor[1]-1]
        end
      else
        cursor = [cursor[0]+1, cursor[1]]
        direction = '>'
      end
    when 'v'
      if board[[cursor[0]-1,cursor[1]]] == '#' || get_values(doors).include?([cursor[0]-1,cursor[1]])
        if board[[cursor[0], cursor[1]+1]] == '#' || get_values(doors).include?([cursor[0],cursor[1]+1])
          if board[[cursor[0]+1, cursor[1]]] == '#' || get_values(doors).include?([cursor[0]+1,cursor[1]])
            cursor = [cursor[0], cursor[1]-1]
            direction = '^'
          else
            cursor = [cursor[0]+1, cursor[1]]
            direction = '>'
          end
        else
          cursor = [cursor[0], cursor[1]+1]
        end
      else
        cursor = [cursor[0]-1, cursor[1]]
        direction = '<'
      end
    when '<'
      if board[[cursor[0],cursor[1]-1]] == '#' || get_values(doors).include?([cursor[0],cursor[1]-1])
        if board[[cursor[0]-1, cursor[1]]] == '#' || get_values(doors).include?([cursor[0]-1,cursor[1]])
          if board[[cursor[0], cursor[1]+1]] == '#' || get_values(doors).include?([cursor[0],cursor[1]+1])
            cursor = [cursor[0]+1, cursor[1]]
            direction = '>'
          else
            cursor = [cursor[0], cursor[1]+1]
            direction = 'v'
          end
        else
          cursor = [cursor[0]-1, cursor[1]]
        end
      else
        cursor = [cursor[0], cursor[1]-1]
        direction = '^'
      end
    when '>'
      if board[[cursor[0], cursor[1]+1]] == '#' || get_values(doors).include?([cursor[0],cursor[1]+1])
        if board[[cursor[0]+1, cursor[1]]] == '#' || get_values(doors).include?([cursor[0]+1,cursor[1]])
          if board[[cursor[0],cursor[1]-1]] == '#' || get_values(doors).include?([cursor[0],cursor[1]-1])
            cursor = [cursor[0]-1, cursor[1]]
            direction = '<'
          else
            cursor = [cursor[0], cursor[1]-1]
            direction = '^'
          end
        else
          cursor = [cursor[0]+1, cursor[1]]
        end
      else
        cursor = [cursor[0], cursor[1]+1]
        direction = 'v'
      end
    end
    if get_values(keys).include?(cursor)
      keys_ret << board[cursor]
      doors, place = remove_door(doors, board[cursor].upcase)
      keys, _ = remove_door(keys, board[cursor])
      board[place] = '.'
    end
    board[cursor] = '@'
    print_grid(board)
    puts "Keys retrieved: #{keys_ret}"
    sleep 0.01
  end
end

0.upto(map.first.length - 1) do |x|
  0.upto(map.length - 1) do |y|
    input = map[y][x]
    board[[x, y]] = map[y][x]
    if /[[:upper:]]/.match(input)
      doors << {input => [x,y]}
    elsif /[[:lower:]]/.match(input)
      keys << {input => [x,y]}
    elsif input == '@'
      cursor = [x,y]
    end
  end
end

puts doors.to_s
puts remove_door(doors, 'S').to_s
puts keys.to_s
puts get_values(keys).to_s
puts cursor.to_s


# distance(board, keys, doors, cursor, [7,5])
# distance(board, keys, doors, cursor, [22,3])
# distance(board, keys, doors, cursor, [15,1])
distance(board, keys, doors, cursor, [22,1])


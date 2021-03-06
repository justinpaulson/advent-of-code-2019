load "int_code.rb"

def print_grid(grid)
  system 'clear'
  -21.upto(20) do |y|
    line = ''
    -21.upto(20) do |x|
      line += grid[[x,y]] || ' '
    end
    puts line
  end
end

code = File.read("day_15_input").split(?,).map(&:to_i)

def move_droid(droid, direction)
  new_droid = droid.clone
  case direction
  when 1
    new_droid = [droid[0], droid[1] - 1]
  when 2
    new_droid = [droid[0], droid[1] + 1]
  when 3
    new_droid = [droid[0] - 1, droid[1]]
  when 4
    new_droid = [droid[0] + 1, droid[1]]
  end
  new_droid
end

def check_north(grid, location)
  grid[[location[0], location[1] - 1]].nil? || grid[[location[0], location[1] - 1]] == '.'
end

def check_south(grid, location)
  grid[[location[0], location[1] + 1]].nil? || grid[[location[0], location[1] + 1]] == '.'
end

def check_west(grid, location)
  grid[[location[0] - 1, location[1]]].nil? || grid[[location[0] - 1, location[1]]] == '.'
end

def check_east(grid, location)
  grid[[location[0] + 1, location[1]]].nil? || grid[[location[0] + 1, location[1]]] == '.'
end

def rotate_input(grid, location, input)
  case input
  when 1
    if check_east(grid, location)
      return 4
    elsif check_north(grid, location)
      return 1
    elsif check_west(grid, location)
      return 3
    else
      return 2
    end
  when 2
    if check_west(grid, location)
      return 3
    elsif check_south(grid, location)
      return 2
    elsif check_east(grid, location)
      return 4
    else
      return 1
    end
  when 3
    if check_north(grid, location)
      return 1
    elsif check_west(grid, location)
      return 3
    elsif check_south(grid, location)
      return 2
    else
      return 4
    end
  when 4
    if check_south(grid, location)
      return 2
    elsif check_east(grid, location)
      return 4
    elsif check_north(grid, location)
      return 1
    else
      return 3
    end
  end
end

input = 1
catcher = IntcodeCatcher.new
room = IntCode.new(code.clone, input, false, catcher)
room.run

droid = [0,0]
board = {}
board[droid] = '@'
while output = catcher.outputs.shift
  case output
  when 0
    board[move_droid(droid, input)] = '#'
    new_input = rotate_input(board, droid, input)
  when 1
    board[droid]= '.'
    droid = move_droid(droid, input)
    board[droid] = '@'
    new_input = rotate_input(board, droid, input)
  when 2
    board[droid]= '.'
    droid = move_droid(droid, input)
    oxygen = droid
    board[oxygen] = 'O'
    new_input = rotate_input(board, droid, input)
  end
  board[oxygen] = 'O' if oxygen
  print_grid(board)
  room.add_input(new_input)
  room.run
  input = new_input
end

board[[0,0]] = 'O'

print_grid(board)

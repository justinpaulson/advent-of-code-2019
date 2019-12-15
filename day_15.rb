load "int_code.rb"
class DummyIntcode
  attr_accessor :inputs
  def initialize
    @inputs = []
  end

  def add_input input
    @inputs << input
  end
end

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

def decode_input(input)
  case input
  when 1 
    return '^'
  when 2 
    return 'v'
  when 3 
    return '<'
  when 4 
    return '>'
  end
end

def rotate_input(grid, location, input)
  case input
  when 1
    if grid[[location[0] + 1, location[1]]].nil? || grid[[location[0] + 1, location[1]]] == '.'
      return 4
    elsif grid[[location[0], location[1] - 1]].nil? || grid[[location[0], location[1] - 1]] == '.'
      return 1
    elsif grid[[location[0] - 1, location[1]]].nil? || grid[[location[0] - 1, location[1]]] == '.'
      return 3
    else
      return 2
    end
  when 2
    if grid[[location[0] - 1, location[1]]].nil? || grid[[location[0] - 1, location[1]]] == '.'
      return 3
    elsif grid[[location[0], location[1] + 1]].nil? || grid[[location[0], location[1] + 1]] == '.'
      return 2
    elsif grid[[location[0] + 1, location[1]]].nil? || grid[[location[0] + 1, location[1]]] == '.'
      return 4
    else
      return 1
    end
  when 3
    if grid[[location[0], location[1] - 1]].nil? || grid[[location[0], location[1] - 1]] == '.'
      return 1
    elsif grid[[location[0] - 1, location[1]]].nil? || grid[[location[0] - 1, location[1]]] == '.'
      return 3
    elsif grid[[location[0], location[1] + 1]].nil? || grid[[location[0], location[1] + 1]] == '.'
      return 2
    else
      return 4
    end
  when 4
    if grid[[location[0], location[1] + 1]].nil? || grid[[location[0], location[1] + 1]] == '.'
      return 2
    elsif grid[[location[0] + 1, location[1]]].nil? || grid[[location[0] + 1, location[1]]] == '.'
      return 4
    elsif grid[[location[0], location[1] - 1]].nil? || grid[[location[0], location[1] - 1]] == '.'
      return 1
    else
      return 3
    end
  end
end

outputs = DummyIntcode.new
room = IntCode.new(code.clone, [1], false, outputs)
room.run

droid = [0,0]
board = {}
board[droid] = '@'
while output = outputs.inputs.shift
  input = inputs.shift
  new_input = input
  case output
  when 0
    wall = move_droid(droid, input)
    board[wall] = '#'
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
  end
  board[oxygen] = 'O' if oxygen
  print_grid(board)
  inputs << new_input
  room.add_input(new_input)
end

board[[0,0]] = 'O'

print_grid(board)
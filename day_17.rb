load "int_code.rb"
code = File.read(ARGV[0]).split(?,).map(&:to_i)

def print_grid(grid)
  system 'clear'
  0.upto(45) do |y|
    line = ''
    0.upto(45) do |x|
      line += grid[[x,y]] || ' '
    end
    puts line
  end
end

def find_intersects(grid)
  intersects = []
  0.upto(44) do |y|
    0.upto(44) do |x|
      if grid[[x,y]] == '#'
        if grid[[x+1,y]] == '#' && grid[[x-1,y]] == '#'  && grid[[x,y+1]] == '#' && grid[[x,y-1]] == '#'
          intersects << [x,y]
        end
      end
    end
  end  
  intersects
end

inputs = []
catcher = IntcodeCatcher.new
room_code = code.clone
room_code[0] = 2
room = IntCode.new(room_code, inputs, false, catcher)

def ascii_code(input)
  input.split('').map(&:ord) + [10]
end

move_a = "R,4,L,10,L,10"
move_b = "L,8,R,12,R,10,R,4"
move_c = "L,8,L,8,R,10,R,4"
routine = "A,B,A,B,A,C,B,C,A,C"
video = "y"

room.add_input(ascii_code(routine))
room.add_input(ascii_code(move_a))
room.add_input(ascii_code(move_b))
room.add_input(ascii_code(move_c))
room.add_input(ascii_code(video))

room.run

board = {}
y = -6 
x = 0
dust = 0
while output = catcher.outputs.shift
  case output
  when 35
    board[[x,y]] = '#'
    x += 1
  when 46
    board[[x,y]]= '.'
    x += 1
  when 60
    board[[x,y]]= '<'
    x += 1
  when 62
    board[[x,y]]= '>'
    x += 1
  when 94
    board[[x,y]]= '^'
    x += 1
  when 118
    board[[x,y]]= 'v'
    x += 1
  when 10
    y += 1
    y = 0 if y == 44
    x = 0
  else
    dust = output if output > 500
  end
  if x== 0 and y == 0
    print_grid(board)
    sleep 0.1
  end 
end
print_grid(board)
puts "Intersections: " + find_intersects(board).to_s
puts "Intersect Total: " + find_intersects(board).inject(0){|i,int| i += int[0] * int[1]}.to_s
puts "Total Dust: " + dust.to_s
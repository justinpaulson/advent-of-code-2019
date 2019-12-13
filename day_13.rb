# \/ turn visuals off or on (only slightly slower with them on) \/
visuals = true
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
  0.upto(20) do |y|
    line = ''
    0.upto(34) do |x|
      line += grid[[x,y]]
    end
    puts line
  end
end

code = File.read("day_13_input").split(?,).map(&:to_i)
code[0] = 2

outputs = DummyIntcode.new
game = IntCode.new(code.clone, [], false, outputs)
game.run

grid = {}
paddle = 0
ball = 0
total = 0
segment_display = 0
remaining_blocks = 100

while remaining_blocks > 0
  outputs.inputs.each_slice(3) do |x, y, tile_id|
    unless x == -1
      case tile_id
      when 0
        grid[[x,y]] = ' '
      when 1
        grid[[x,y]] = '#'
      when 2
        grid[[x,y]] = 'x'
      when 3
        grid[[x,y]] = '-'
        paddle = x
      when 4
        grid[[x,y]] = 'o'
        ball = x
      end
    else
      segment_display = tile_id
    end
  end
  if visuals
    print_grid(grid)
    puts "Total Initial boxes: #{total}"
    puts "Remaining Blocks: #{remaining_blocks}"
    puts "Score: #{segment_display}"
    sleep 0.00001
  end
  if paddle < ball
    game.add_input(1)
  elsif ball < paddle
    game.add_input(-1)
  else
    game.add_input(0)
  end
  remaining_blocks = grid.map{|_, line| line == 'x' ? 1 : 0}.sum
  total = total < remaining_blocks ? remaining_blocks : total
end

unless visuals
  puts "Total Initial boxes: #{total}"
  puts "Final Score: #{segment_display}"
end

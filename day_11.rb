load "int_code.rb"
class DummyIntcode
  attr_accessor :inputs
  def initialize
    @inputs = []
    @count = 0
    @accessed = 0
  end

  def add_input input
    @inputs << input
    @count += 1
  end
end

def move_right(position)
  case position[2]
  when '^'
    return [position[0] + 1, position[1], '>']
  when 'v'
    return [position[0] - 1, position[1], '<']
  when '<'
    return [position[0], position[1] - 1, '^']
  when '>'
    return [position[0], position[1] + 1, 'v']
  end
end

def move_left(position)
  case position[2]
  when '^'
    return [position[0] - 1, position[1], '<']
  when 'v'
    return [position[0] + 1, position[1], '>']
  when '<'
    return [position[0], position[1] + 1, 'v']
  when '>'
    return [position[0], position[1] - 1, '^']
  end
end

def print_position(panels, position, inputs)
  system 'clear'
  0.upto(30) do |y|
    panel = []
    0.upto(100) do |x|
      if [position[0], position[1]] == [x, y]
        panel << position[2]
      else
        panel << panels[[x,y]]
      end
    end
    puts panel.join('')
  end
  sleep 0.005
end

def paint_hull(computer, outputs, print = false)
  panels = Hash.new
  0.upto(30) do |y|
    0.upto(100) do |x|
      panels[[x,y]] = '.'
    end
  end
  position = [15, 10, '^']

  index = 0
  colored_panels = []
  computer.run
  while color = outputs.inputs[index]
    index += 1
    if color == 0
      panels[[position[0],position[1]]] = '.'
    else
      colored_panels << position[0..1] unless colored_panels.include?(position[0..1])
      panels[[position[0],position[1]]] = '#'
    end
    if outputs.inputs[index] == 1
      position = move_right(position)
    else
      position = move_left(position)
    end
    index += 1
    print_position(panels, position, outputs) if print
    if panels[[position[0], position[1]]] == '#'
      computer.add_input(1)
    else
      computer.add_input(0)
    end
  end

  puts "Total painted (will dissappear in 10s): #{colored_panels.count}"
  sleep 10
end

code = File.read(ARGV[0]).split(?,).map(&:to_i)

outputs = DummyIntcode.new
computer = IntCode.new(code.clone, [0], false, outputs)

paint_hull(computer, outputs)

outputs_2 = DummyIntcode.new
computer_2 = IntCode.new(code.clone, [1], false, outputs_2)

paint_hull(computer_2, outputs_2, true)

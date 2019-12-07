original_intcode = File.read(ARGV[0]).split(?,).map(&:to_i)

def run_intcode(intcode, inputs, cursor = 0)
  val = false
  while cursor < intcode.length - 1
    input = nil
    code = intcode[cursor]
    opcode = code.to_s.split('').last(2).join('').to_i
    modes = code.to_s.split('').reverse.drop(2)
    param_1 = modes[0] == '1' ? intcode[cursor + 1] : intcode[intcode[cursor + 1]] if cursor < intcode.length - 2
    param_2 = modes[1] == '1' ? intcode[cursor + 2] : intcode[intcode[cursor + 2]] if cursor < intcode.length - 3
    target = intcode[cursor + 3] if cursor < intcode.length - 4
    case opcode
    when 1
      intcode[target] = param_1 + param_2
      cursor += 4
    when 2
      intcode[target] = param_1 * param_2
      cursor += 4
    when 3
      intcode[intcode[cursor + 1]] = inputs.pop
      cursor += 2
    when 4
      cursor += 2
      return param_1
    when 5
      cursor = param_1 > 0 ? param_2 : cursor + 3
    when 6
      cursor = param_1 == 0 ? param_2 : cursor + 3
    when 7
      intcode[target] = param_1 < param_2 ? 1 : 0
      cursor += 4
    when 8
      intcode[target] = param_1 == param_2 ? 1 : 0
      cursor += 4
    when 99
      return false
    end
  end
end

phases = []
max = 0
0.upto(4) do |phase_1|
  0.upto(4) do |phase_2|
    0.upto(4) do |phase_3|
      0.upto(4) do |phase_4|
        0.upto(4) do |phase_5|
          next unless [phase_1, phase_2, phase_3, phase_4, phase_5].uniq == [phase_1, phase_2, phase_3, phase_4, phase_5]

          intcode = original_intcode.clone
          inputs = [0, phase_1]
          new_code = run_intcode(intcode, inputs)
          inputs = [new_code, phase_2]
          new_code = run_intcode(intcode, inputs)
          inputs = [new_code, phase_3]
          new_code = run_intcode(intcode, inputs)
          inputs = [new_code, phase_4]
          new_code = run_intcode(intcode, inputs)
          inputs = [new_code, phase_5]
          answer = run_intcode(intcode, inputs)
          if answer > max
            max = answer
            phases = [phase_1, phase_2, phase_3, phase_4, phase_5]
          end
        end
      end
    end
  end
end

puts "Max Phases Part 1: " + phases.to_s
puts "Max Part 1: " + max.to_s

class Amp
  attr_accessor :phase, :next_amp, :output, :final_output

  def initialize(phase, original_intcode, next_amp, final_amp = false)
    @phase = phase
    @cursor = 0
    @intcode = original_intcode.clone
    @inputs = [@phase]
    @next_amp = next_amp
    @final_amp = final_amp
    @stopped = true
  end

  def run
    while @output = run_intcode
      if @output == :stopped
        @stopped = true
        break
      else
        push_output
      end
    end
  end

  def run_intcode
    @stopped = false
    while @cursor < @intcode.length - 1
      code = @intcode[@cursor]
      opcode = code.to_s.split('').last(2).join('').to_i
      modes = code.to_s.split('').reverse.drop(2)
      param_1 = modes[0] == '1' ? @intcode[@cursor + 1] : @intcode[@intcode[@cursor + 1]] if @cursor < @intcode.length - 2
      param_2 = modes[1] == '1' ? @intcode[@cursor + 2] : @intcode[@intcode[@cursor + 2]] if @cursor < @intcode.length - 3
      target = @intcode[@cursor + 3] if @cursor < @intcode.length - 4
      case opcode
      when 1
        @intcode[target] = param_1 + param_2
        @cursor += 4
      when 2
        @intcode[target] = param_1 * param_2
        @cursor += 4
      when 3
        return :stopped unless input = @inputs.pop
         
        @intcode[@intcode[@cursor + 1]] = input
        @cursor += 2
      when 4
        @cursor += 2
        return param_1
      when 5
        @cursor = param_1 > 0 ? param_2 : @cursor + 3
      when 6
        @cursor = param_1 == 0 ? param_2 : @cursor + 3
      when 7
        @intcode[target] = param_1 < param_2 ? 1 : 0
        @cursor += 4
      when 8
        @intcode[target] = param_1 == param_2 ? 1 : 0
        @cursor += 4
      when 99
        return false
      end
    end
  end

  def add_input(input)
    @inputs.unshift(input)
    run if @stopped
  end

  def push_output
    @next_amp.add_input(@output)
    if @final_amp
      @final_output = @output
    end
  end
end

phases = []
max = 0
5.upto(9) do |phase_1|
  5.upto(9) do |phase_2|
    5.upto(9) do |phase_3|
      5.upto(9) do |phase_4|
        5.upto(9) do |phase_5|
          next unless [phase_1, phase_2, phase_3, phase_4, phase_5].uniq == [phase_1, phase_2, phase_3, phase_4, phase_5]
          
          amp_5 = Amp.new(phase_5, original_intcode, nil, true)
          amp_4 = Amp.new(phase_4, original_intcode, amp_5,)
          amp_3 = Amp.new(phase_3, original_intcode, amp_4,)
          amp_2 = Amp.new(phase_2, original_intcode, amp_3,)
          amp_1 = Amp.new(phase_1, original_intcode, amp_2,)
          amp_5.next_amp = amp_1

          amp_1.add_input(0)

          answer = amp_5.final_output
          
          if answer > max
            max = answer
            phases = [phase_1, phase_2, phase_3, phase_4, phase_5]
          end
        end
      end
    end
  end
end

puts "Max Phases Part 2: " + phases.to_s
puts "Max Part 2: " + max.to_s
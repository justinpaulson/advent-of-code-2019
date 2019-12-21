class IntCode
  attr_accessor :next_intcode, :final_output, :inputs

  def initialize(intcode, inputs, print_output = true, next_intcode = nil)
    @cursor = 0
    @intcode = intcode.clone
    @inputs = []
    @stopped = true
    @next_intcode = next_intcode
    @print_output = print_output
    @relative_base = 0
    @intcode.length.upto(10000){|i| @intcode[i] = 0}
    @final_output = nil
    add_input(inputs)
  end

  def run
    while @output = run_intcode
      puts @output if @print_output
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
    while true
      code = @intcode[@cursor]
      opcode = code.to_s.split('').last(2).join('').to_i
      modes = code.to_s.split('').reverse.drop(2)
      code_1 = @intcode[@cursor + 1]
      code_2 = @intcode[@cursor + 2]
      code_3 = @intcode[@cursor + 3]
      index_1 = modes[0] == '2' ? code_1 + @relative_base : code_1
      index_2 = modes[1] == '2' ? code_2 + @relative_base : code_2
      index_3 = modes[2] == '2' ? code_3 + @relative_base : code_3
      param_1 = modes[0] == '1' ? index_1 : @intcode[index_1]
      param_2 = modes[1] == '1' ? index_2 : @intcode[index_2]
      target = index_3
      case opcode
      when 1
        @intcode[target] = param_1 + param_2
        @cursor += 4
      when 2
        @intcode[target] = param_1 * param_2
        @cursor += 4
      when 3
        return :stopped unless input = @inputs.pop

        @intcode[index_1] = input
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
      when 9
        @relative_base += param_1
        @cursor += 2
      when 99
        return false
      end
    end
  end

  def add_input(input)
    if input.is_a?(Array)
      if input.first.is_a?(String)
        input_ascii_codes(input)
      else
        input.each{|i| @inputs.unshift(i)}
      end
    else
      if input.is_a?(String)
        input_ascii_codes(input)
      else
        @inputs.unshift(input)
      end
    end
  end

  def input_ascii_codes(ascii)
    if ascii.is_a?(Array)
      add_input(ascii.map{|i| i.split('').map(&:ord) + [10]}.flatten)
    else
      add_input(ascii.split('').map(&:ord) + [10])
    end
  end

  def push_output
    if @next_intcode
      @next_intcode.add_input(@output.clone)
      @next_intcode.run
    end
    @final_output = @output if @output
  end
end


class IntcodeCatcher
  attr_accessor :outputs
  def initialize
    @outputs = []
  end

  def add_input input
    @outputs << input
  end
end

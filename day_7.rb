load 'int_code.rb'
code = File.read(ARGV[0]).split(?,).map(&:to_i)

def find_max(opening, ending, code)
  phases = []
  max = 0
  opening.upto(ending) do |phase_1|
    opening.upto(ending) do |phase_2|
      opening.upto(ending) do |phase_3|
        opening.upto(ending) do |phase_4|
          opening.upto(ending) do |phase_5|
            phases = [phase_1, phase_2, phase_3, phase_4, phase_5]
            next unless phases.uniq == phases
            
            amp_5 = IntCode.new(code, [phase_5], false)
            amp_4 = IntCode.new(code, [phase_4], false, amp_5, false)
            amp_3 = IntCode.new(code, [phase_3], false, amp_4, false)
            amp_2 = IntCode.new(code, [phase_2], false, amp_3, false)
            amp_1 = IntCode.new(code, [phase_1], false, amp_2, false)
            amp_5.next_intcode = amp_1

            amp_1.add_input(0)

            answer = amp_5.final_output
            
            if answer > max
              max = answer
            end
          end
        end
      end
    end
  end
  max
end

puts "Max Part 1: " + find_max(0, 4, code).to_s

puts "Max Part 2: " + find_max(5, 9, code).to_s
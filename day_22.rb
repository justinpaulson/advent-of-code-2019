inputs = File.readlines(ARGV[0])

def deal_into_new_stack(stack)
  stack.reverse
end

def cut(stack, index)
  index = stack.length + index if index < 0
  stack.last(stack.length - index) + stack[0..index-1]
end

def deal_with_increment(stack, freq)
  out_stack = []
  stack.each_with_index{|e, i| out_stack[i * freq % stack.length] = e}
  out_stack
end

# size = 10
# stack = []
# 0.upto(size - 1){|x| stack << x}
# inputs.each do |input|
#   split_ins = input.split(' ')
#   case split_ins[0..-2].join('')
#   when 'dealwithincrement'
#     stack = deal_with_increment(stack, split_ins.last.to_i)
#   when 'dealintonew'
#     stack = deal_into_new_stack(stack)
#   when 'cut'
#     stack = cut(stack, split_ins.last.to_i)
#   end
# end
# puts stack.to_s

size = 10007
stack = []
0.upto(size - 1){|x| stack << x}
inputs.each do |input|
  split_ins = input.split(' ')
  case split_ins[0..-2].join('')
  when 'dealwithincrement'
    stack = deal_with_increment(stack, split_ins.last.to_i)
  when 'dealintonew'
    stack = deal_into_new_stack(stack)
  when 'cut'
    stack = cut(stack, split_ins.last.to_i)
  end
end
stack.each_with_index{|s, i| puts i if s == 2019}

# size = 119315717514047
# stack = []
# results = []
# 0.upto(size - 1){|x| stack << x}
# 1.upto(101741582076661) do |s|
#   inputs.each do |input|
#     split_ins = input.split(' ')
#     case split_ins[0..-2].join('')
#     when 'dealwithincrement'
#       puts "Deal With Inc"
#       stack = deal_with_increment(stack, split_ins.last.to_i)
#     when 'dealintonew'
#       puts "Deal Into new"
#       stack = deal_into_new_stack(stack)
#     when 'cut'
#       puts "Cut"
#       stack = cut(stack, split_ins.last.to_i)
#     end
#     if results.include?(stack)
#       puts "CYCLE WAS FOUND AT INDEX: #{s}"
#       return
#     else
#       results << stack
#     end
#   end
#   puts s
# end
# stack.each_with_index{|s, i| puts i if s == 2020}

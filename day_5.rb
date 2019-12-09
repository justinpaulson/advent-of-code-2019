load "int_code.rb"

intcode = File.read(ARGV[0]).split(?,).map(&:to_i)
input = (ARGV[1] || 1).to_i

IntCode.new(intcode, [input]).run

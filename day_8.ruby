image_ints = File.read(ARGV[0]).split('').map(&:to_i)

width = 25
height = 6

layers = []
cursor = 0
while cursor < image_ints.count - 1
  layers << image_ints[cursor..(cursor+(width * height)-1)]
  cursor += width * height
end

min_layer = layers.min do |l1, l2|
  l1.select{|l| l == 0}.count <=> l2.select{|l| l == 0}.count
end
zeroes = min_layer.select{|l| l == 0}.count
ones = min_layer.select{|l| l == 1}.count
twos = min_layer.select{|l| l == 2}.count

puts "Min Layer: "
min_layer.each_slice(width){|layer| puts layer.join('')}
puts "Number of zeroes: " + zeroes.to_s
puts "Total ones and twos from row with min 0s: " + ((ones) * (twos)).to_s

image = []
layers[0].each_with_index do |pixel, i|
  unless pixel == 2
    image << pixel
  else
    1.upto(layers.count-1) do |layer|
      unless layers[layer][i] == 2
        image << layers[layer][i]
        break
      end
    end
  end
end

cursor = 0
0.upto(height-1) do |y|
  puts image[cursor..cursor+width-1].map{|char| char == 1 ? "\u2588" : " "}.join('')
  cursor += width
end

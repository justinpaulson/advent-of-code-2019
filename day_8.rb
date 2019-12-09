image_ints = File.read(ARGV[0]).split('').map(&:to_i)
width = 25
height = 6

layers = *(0..(image_ints.count / (width * height) - 1)).map do |cursor|
  image_ints[cursor*(width*height)..(cursor*(width*height))+(width * height)-1]
end

min_layer = layers.min do |l1, l2|
  l1.select{|l| l == 0}.count <=> l2.select{|l| l == 0}.count
end
ones = min_layer.select{|l| l == 1}.count
twos = min_layer.select{|l| l == 2}.count

puts "Total ones and twos multiplied in layer with min 0s: " + ((ones) * (twos)).to_s

image = layers.inject(layers[0]) do |res, layer|
  layer.map.with_index do |pixel, i|
    res[i] == 2 ? pixel : res[i]
  end
end

0.upto(height-1) do |y|
  puts image[y*width..y*width+width-1].map{|char| char == 1 ? "\u2588" : " "}.join('')
end

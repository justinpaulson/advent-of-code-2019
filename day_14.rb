class Reaction
  attr_accessor :name, :quantity, :inputs
  def initialize(reaction = nil)
    if reaction
      inputs, output = reaction.split(' => ')
      @name = output.split(' ')[1]
      @quantity = output.split(' ')[0].to_i
      @inputs = inputs.split(',').map{|i| {name: i.split(' ')[1], quantity: i.split(' ')[0].to_i}}
    else
      @name = "ORE"
      @quantity = 1
      @inputs = []
    end
  end

  def to_s
    "Name: #{@name}, Quantity: #{@quantity}, Inputs: #{@inputs.map{|i| i[:name] + ': ' + i[:quantity].to_s}.join(' ')}"
  end

  def ore_with_overage(reactions, quantity, overages)
    if overage = overages[@name]
      overages[@name] = overage - quantity
      overages[@name] = overages[@name] > 0 ? overages[@name] : 0
      quantity = quantity - overage
      return 0, overages if quantity <= 0
    end

    if @name == "ORE"
      return quantity, overages 
    end

    multiplier = 1
    if quantity < @quantity
      overages[@name] ||= 0
      overages[@name] += @quantity - quantity
    elsif @quantity < quantity
      multiplier = quantity / @quantity
      multiplier += 1 if quantity % @quantity != 0
      overages[@name] ||=0
      overages[@name] += ((@quantity * multiplier) % quantity)
    end
    total_quantity = 0
    @inputs.each do |input|
      reaction = reactions.select{|r| r.name == input[:name]}.first
      input_quantity, overages = reaction.ore_with_overage(reactions, input[:quantity] * multiplier, overages)
      total_quantity += input_quantity
    end
    return total_quantity, overages
  end
end

def in_history?(histories, overages)
  histories.each_with_index do |overs, i|
    ret = true
    overages.each do |k,v|
      ret = false unless overs[k] == v
    end
    return ret, i if ret
  end
  return false, -1
end

reactions = [Reaction.new] + File.readlines(ARGV[0]).map{|r| Reaction.new(r)}

fuel = reactions.select{|r| r.name == "FUEL"}.first

quantity, overages = fuel.ore_with_overage(reactions, 1, {})

puts "Quantity of ORE needed for 1 FUEL: #{quantity}"
puts "This next part is slow, get some coffee and wait.... "

max_ore = 1000000000000 - quantity

total = 1
overage_history = [overages.clone]
while max_ore > quantity
  total += 1
  max_ore = max_ore - quantity
  quantity, overages = fuel.ore_with_overage(reactions, 1, overages)
  #uncomment for cycles
  # in_hist, index = in_history?(overage_history, overages)
  # if in_hist
  #   puts "Cycle found: " + total.to_s
  #   ore_per_cycle = 1000000000000 - max_ore
  #   puts "Used this much ore for the cycle: " + ore_per_cycle.to_s
  #   puts "At Index: " + index.to_s
  #   puts max_ore
  #   puts "Total fuel: " + ((1000000000000 / ore_per_cycle) * total).to_s
  #   break
  # end
  if total % 10000 == 0
    puts total
    puts max_ore
  end
end

puts total



#too low:  1275681
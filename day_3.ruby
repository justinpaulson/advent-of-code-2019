first_path, second_path = File.readlines(ARGV[0]).map{|input| input.split(?,)}

def get_points_in_path(path)
  current_position = [0,0]
  [[0, 0]] + path.map do |direction|
    if direction.start_with? 'U'
      current_position[0] += direction.delete_prefix('U').to_i
    elsif direction.start_with? 'R'
      current_position[1] += direction.delete_prefix('R').to_i
    elsif direction.start_with? 'L'
      current_position[1] -= direction.delete_prefix('L').to_i
    elsif direction.start_with? 'D'
      current_position[0] -= direction.delete_prefix('D').to_i
    end
    current_position.clone
  end
end

points_in_path_1 = get_points_in_path(first_path)
points_in_path_2 = get_points_in_path(second_path)

puts "Points in path 1: " + points_in_path_1.to_s
puts "Points in path 2: " + points_in_path_2.to_s

intersections = []
points_in_path_1.each_with_index do |point, i|
  next_point = points_in_path_1[i+1]
  next unless next_point
  if next_point[0] == point[0]
    points_in_path_2.select.with_index do |p, p_i|
      p2 = points_in_path_2[p_i + 1]
      next unless p2
      if (p[0] >= next_point[0] && p2[0] <= next_point[0] ||
        p[0] <= next_point[0] && p2[0] >= next_point[0]) &&
        p[1] >= [next_point[1], point[1]].min &&
        p[1] <= [next_point[1], point[1]].max
        intersections << [next_point[0], p[1]]
      end
    end
  elsif next_point[1] == point[1]
    points_in_path_2.select.with_index do |p, p_i|
      p2 = points_in_path_2[p_i + 1]
      next unless p2
      if (p[1] >= next_point[1] && p2[1] <= next_point[1] ||
        p[1] <= next_point[1] && p2[1] >= next_point[1]) &&
        p[0] >= [next_point[0], point[0]].min &&
        p[0] <= [next_point[0], point[0]].max
        intersections << [p[0], next_point[1]]
      end
    end
  end
end

puts "Intersecting points: " + intersections.to_s

min_point = intersections.drop(1).map{|p| p[0].abs + p[1].abs}.min

puts "Nearest Manhattan distance to [0, 0]: " + min_point.to_s

def get_steps_for_point(path_points, point)
  steps = 0
  0.upto(path_points.length - 1) do |i|
    current_point = path_points[i]
    next_point = path_points[i+1]
    next unless next_point
    if current_point[0] == point[0]
      if (point[1] < current_point[1] && point[1] > next_point[1]) ||
        (point[1] > current_point[1] && point[1] < next_point[1])
        steps += (current_point[1] - point[1]).abs
        break
      end
    elsif current_point[1] == point[1]
      if (point[0] < current_point[0] && point[0] > next_point[0]) ||
        (point[0] > current_point[0] && point[0] < next_point[0])
        steps += (current_point[0] - point[0]).abs
        break
      end
    else
      steps += (current_point[0] - next_point[0]).abs + (current_point[1] - next_point[1]).abs
    end
  end
  steps
end

steps_path_1 = intersections.drop(1).map{|p| get_steps_for_point(points_in_path_1, p)}
steps_path_2 = intersections.drop(1).map{|p| get_steps_for_point(points_in_path_2, p)}

puts "Steps for Path 1: " + steps_path_1.to_s
puts "Steps for Path 2: " + steps_path_2.to_s
puts "Total steps: " + [steps_path_1, steps_path_2].transpose.map(&:sum).to_s
puts "Min total steps: " + [steps_path_1, steps_path_2].transpose.map(&:sum).min.to_s

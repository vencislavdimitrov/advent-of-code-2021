input = File.read(File.basename(__FILE__).gsub('rb', 'input'))
input = input.split("\n")

cubes = {}
input.each do |step|
  on, area = step.split(' ')
  on = on == 'on'
  x, y, z = area.split(',').map { eval(_1.split('=')[1]) }
  x.each do |i|
    next if i < -50
    break if i > 50

    y.each do |j|
      next if j < -50
      break if j > 50
      z.each do |k|
        next if k < -50
        break if k > 50

        cubes[[i, j, k]] = on
      end
    end
  end
end
p cubes.values.count { _1 == true }

def parse_step(step)
  on, area = step.split(' ')
  on = on == 'on'
  x, y, z = area.split(',').map { _1.split('=')[1].split('..').map(&:to_i) }.map { [_1, _2 + 1] }
  [on, x, y, z]
end

def volume(x, y, z)
  (x[1] - x[0]) * (y[1] - y[0]) * (z[1] - z[0])
end

def intersect(x_i, y_i, z_i, x_j, y_j, z_j)
  [x_i.min, x_j.min].max < [x_i.max, x_j.max].min &&
    [y_i.min, y_j.min].max < [y_i.max, y_j.max].min &&
    [z_i.min, z_j.min].max < [z_i.max, z_j.max].min
end

cubes = {}
(0...input.size).each do |step_i|
  on_i, x_i, y_i, z_i = parse_step input[step_i]

  cubes.keys.each do |cube|
    next unless intersect cube[0], cube[1], cube[2], x_i, y_i, z_i

    cubes.delete cube

    new_x = (cube[0] + x_i).sort
    new_y = (cube[1] + y_i).sort
    new_z = (cube[2] + z_i).sort

    new_x.each_cons(2) do |x_k|
      new_y.each_cons(2) do |y_k|
        new_z.each_cons(2) do |z_k|
          if intersect(cube[0], cube[1], cube[2], x_k, y_k, z_k) && !intersect(x_i, y_i, z_i, x_k, y_k, z_k)
            cubes[[x_k, y_k, z_k]] = true
          end
        end
      end
    end
  end
  cubes[[x_i, y_i, z_i]] = true if on_i
end

p cubes.keys.sum { volume _1[0], _1[1], _1[2] }

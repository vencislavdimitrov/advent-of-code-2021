input = File.read(File.basename(__FILE__).gsub('rb', 'input'))
dots, folds = input.split("\n\n")

dots = dots.split("\n").map { _1.split(',').map(&:to_i) }
folds = folds.split("\n").map { _1.split(' ').last }

def do_fold(dots, fold)
  direction, col = fold.split('=')
  col = col.to_i
  new_dots = []
  if direction == 'y'
    dots.each do |d|
      new_dots << (d[1] < col ? d : [d[0], 2 * col - d[1]])
    end
  else
    dots.each do |d|
      new_dots << (d[0] < col ? d : [2 * col - d[0], d[1]])
    end
  end
  new_dots.uniq
end

p do_fold(dots, folds[0]).size

folds.each do |fold|
  dots = do_fold dots, fold
end

x = dots.map { _1[0] }.max
y = dots.map { _1[1] }.max

(0..y).each do |i|
  line = ''
  (0..x).each do |j|
    line += dots.include?([j, i]) ? '#' : ' '
  end
  puts line
end

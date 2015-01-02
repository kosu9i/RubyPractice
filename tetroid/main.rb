#!/usr/bin/ruby
# -*- coding: utf-8 -*-

$count = 1

# 入力を x, y の座標に分割
def split_input(input)
  points = input.split(',')
  points.each_with_index do |p, i|
    tmp = [0, 0]
    tmp[0] = p[0].to_i
    tmp[1] = p[1].to_i
    points[i] = tmp
  end
  points.sort
end

# 重複座標をチェック
def check_duplicate(points)
  if points.size != points.uniq.size
    raise 'dupulicate.'
  end
end

# I だけ先に別途判定
def judge_I(points)
  type = ""
  if points[0][0] == points[1][0] and
     points[0][0] == points[2][0] and 
     points[0][0] == points[3][0]
    type = "vertical"

  elsif points[0][1] == points[1][1] and
        points[0][1] == points[2][1] and 
        points[0][1] == points[3][1]
    type = "horizon"
  else  
    return false
  end

  prev = points[0]
  points[1..-1].each do |p|
    if type == "vertical"
      if p[1] != prev[1] + 1
        return false
      end
    else
      if p[0] != prev[0] + 1
        return false
      end
    end
    prev = p
  end

  return true
end

# L の字を見つける。見つからなかったらテトロミノは完成しない。
class Tetro
  def initialize(points)
    @points = points
    @center = nil
    @arm_x = nil
    @arm_y = nil
  end

  def create_body
    tmp_center = nil
    tmp_arm_x = nil
    tmp_arm_y = nil
    tmp_other = nil
    @points.each_with_index do |c, i|
      tmp_center = i

      (0..3).each do |j|
        next if j == i
        if (@points[j][0] - @points[i][0]).abs == 1 and 
           (@points[j][1] - @points[i][1]).abs == 0
          tmp_arm_x = j
        elsif (@points[j][1] - @points[i][1]).abs == 1 and
              (@points[j][0] - @points[i][0]).abs == 0 
          tmp_arm_y = j
        else
          tmp_other = j
        end
      end

      if tmp_arm_x.nil? or tmp_arm_y.nil?
        tmp_arm_x = nil
        tmp_arm_y = nil
        tmp_other = nil
      else
        break
      end
    end
    
    if tmp_arm_x.nil? or tmp_arm_y.nil?
      raise 'can not create body.'
    else
      @center = tmp_center
      @arm_x = tmp_arm_x
      @arm_y = tmp_arm_y
      @other = tmp_other
      if tmp_other.nil?
        (0..3).each do |i|
          if i != @arm_x and i != @arm_y and i != @center
            @other = i
          end
        end
      end
    end

  end

  def create_tetro
    if (@points[@other][0] - @points[@center][0]).abs == 1 and
       (@points[@other][1] - @points[@center][1]).abs == 1 and
       (@points[@other][0] - @points[@arm_x][0]).abs == 0 and
       (@points[@other][1] - @points[@arm_x][1]).abs == 1 and
       (@points[@other][0] - @points[@arm_y][0]).abs == 1 and
       (@points[@other][1] - @points[@arm_y][1]).abs == 0

      return "O"
    end

    if ((@points[@other][0] - @points[@center][0]).abs == 1 and
        (@points[@other][1] - @points[@center][1]).abs == 0 and
        (@points[@other][0] - @points[@arm_x][0]).abs == 2 and
        (@points[@other][1] - @points[@arm_x][1]).abs == 0 and
        (@points[@other][0] - @points[@arm_y][0]).abs == 1 and
        (@points[@other][1] - @points[@arm_y][1]).abs == 1) or
       ((@points[@other][0] - @points[@center][0]).abs == 0 and
        (@points[@other][1] - @points[@center][1]).abs == 1 and
        (@points[@other][0] - @points[@arm_x][0]).abs == 1 and
        (@points[@other][1] - @points[@arm_x][1]).abs == 1 and
        (@points[@other][0] - @points[@arm_y][0]).abs == 0 and
        (@points[@other][1] - @points[@arm_y][1]).abs == 2)
      return "T"
    end

    if ((@points[@other][0] - @points[@center][0]).abs == 2 and
        (@points[@other][1] - @points[@center][1]).abs == 0 and
        (@points[@other][0] - @points[@arm_x][0]).abs == 1 and
        (@points[@other][1] - @points[@arm_x][1]).abs == 0 and
        (@points[@other][0] - @points[@arm_y][0]).abs == 2 and
        (@points[@other][1] - @points[@arm_y][1]).abs == 1) or
       ((@points[@other][0] - @points[@center][0]).abs == 0 and
        (@points[@other][1] - @points[@center][1]).abs == 2 and
        (@points[@other][0] - @points[@arm_x][0]).abs == 1 and
        (@points[@other][1] - @points[@arm_x][1]).abs == 2 and
        (@points[@other][0] - @points[@arm_y][0]).abs == 0 and
        (@points[@other][1] - @points[@arm_y][1]).abs == 1)
      return "L"
    end
    
    if ((@points[@other][0] - @points[@center][0]).abs == 1 and
        (@points[@other][1] - @points[@center][1]).abs == 1 and
        (@points[@other][0] - @points[@arm_x][0]).abs == 0 and
        (@points[@other][1] - @points[@arm_x][1]).abs == 1 and
        (@points[@other][0] - @points[@arm_y][0]).abs == 1 and
        (@points[@other][1] - @points[@arm_y][1]).abs == 2) or
       ((@points[@other][0] - @points[@center][0]).abs == 1 and
        (@points[@other][1] - @points[@center][1]).abs == 1 and
        (@points[@other][0] - @points[@arm_x][0]).abs == 2 and
        (@points[@other][1] - @points[@arm_x][1]).abs == 1 and
        (@points[@other][0] - @points[@arm_y][0]).abs == 1 and
        (@points[@other][1] - @points[@arm_y][1]).abs == 0)
      return "S"
    end
    raise 'not found other.'
  end
end

def judge_other(points)
  tetro = Tetro.new(points)
  tetro.create_body
  ret = tetro.create_tetro
  ret
end

def analyze(points)
  ret = "-"
  begin
    check_duplicate(points)

    # 先に I のみ判定
    if judge_I(points)
      return "I"
    end

    ret = judge_other(points)
  rescue => e
    return "-"
  end

  return ret

end

def test(input, actual)
  points = split_input(input)
  pred = analyze(points)
  #puts "#{$count}\t#{pred}"
  if pred == actual
    puts "#{$count}\tOK.\t'#{pred}'\t'#{actual}'"
  else
    puts "#{$count}\tNG.\t'#{pred}'\t'#{actual}'"
  end
  $count += 1
end

test("55,55,55,55", "-")
test("07,17,06,05", "L")
test("21,41,31,40", "L")
test("62,74,73,72", "L")
test("84,94,74,75", "L")
test("48,49,57,47", "L")
test("69,89,79,68", "L")
test("90,82,91,92", "L")
test("13,23,03,24", "L")
test("24,22,25,23", "I")
test("51,41,21,31", "I")
test("64,63,62,65", "I")
test("49,69,59,79", "I")
test("12,10,21,11", "T")
test("89,99,79,88", "T")
test("32,41,43,42", "T")
test("27,16,36,26", "T")
test("68,57,58,67", "O")
test("72,62,61,71", "O")
test("25,24,15,14", "O")
test("43,54,53,42", "S")
test("95,86,76,85", "S")
test("72,73,84,83", "S")
test("42,33,32,23", "S")
test("66,57,67,58", "S")
test("63,73,52,62", "S")
test("76,68,77,67", "S")
test("12,11,22,01", "S")
test("05,26,06,25", "-")
test("03,11,13,01", "-")
test("11,20,00,21", "-")
test("84,95,94,86", "-")
test("36,56,45,35", "-")
test("41,33,32,43", "-")
test("75,94,84,95", "-")
test("27,39,28,37", "-")
test("45,34,54,35", "-")
test("24,36,35,26", "-")
test("27,27,27,27", "-")
test("55,44,44,45", "-")
test("70,73,71,71", "-")
test("67,37,47,47", "-")
test("43,45,41,42", "-")
test("87,57,97,67", "-")
test("49,45,46,48", "-")
test("63,63,52,72", "-")
test("84,86,84,95", "-")
test("61,60,62,73", "-")
test("59,79,69,48", "-")
test("55,57,77,75", "-")

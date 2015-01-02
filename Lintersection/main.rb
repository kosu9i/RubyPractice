#!/usr/bin/ruby
# -*- coding: utf-8 -*-

$count = 1

# 入力を各座標に分割
def _split_input(input)
  points = input.split('-')
  points.each_with_index do |p, i|
    tmp = [0, 0]
    tmp[0] = p[0].to_i
    tmp[1] = p[1].to_i
    points[i] = tmp
  end
  points
end

def split_input(input1, input2)
  points1 = _split_input(input1)
  points2 = _split_input(input2)
  return points1, points2
end

class Area
  def initialize(points)
    @points = points
    @area = Array.new(10){Array.new(10, false)}
  end

  def _create_area(index)
    x_max = [@points[0][0], @points[index][0]].max
    x_min = [@points[0][0], @points[index][0]].min
    y_max = [@points[0][1], @points[index][1]].max
    y_min = [@points[0][1], @points[index][1]].min
    
    (x_min..x_max).each do |x|
      (y_min..y_max).each do |y|
        @area[x][y] = true
      end
    end
  end

  # 長方形ごとに領域を埋めていく
  def create_area
    _create_area(1)
    _create_area(2)
    return @area
  end
  
end

# 重なっているマスの数を計算
def calc_dup_area(area1_arr, area2_arr)
  count = 0
  (0..9).each do |i|
    (0..9).each do |j|
      if area1_arr[i][j] && area2_arr[i][j]
        count += 1
      end
    end
  end
  return count
end

def test(input1, input2, actual)
  points1, points2 = split_input(input1, input2)
  area1 = Area.new(points1)
  area2 = Area.new(points2)

  area1_arr = area1.create_area
  area2_arr = area2.create_area

  pred = calc_dup_area(area1_arr, area2_arr)
  puts "#{$count}\t#{pred}\t#{actual}"
  $count += 1
end


test("23-94-28","89-06-51","11")
test("11-84-58","02-73-69","40")
test("18-41-86","77-04-32","26")
test("81-88-23","64-58-14","0")
test("31-29-07","41-87-69","0")
test("83-13-40","18-10-94","1")
test("77-80-92","21-72-38","2")
test("57-70-91","55-19-08","3")
test("18-22-75","66-80-91","4")
test("51-93-78","54-49-06","5")
test("58-70-96","17-43-76","6")
test("58-07-12","58-82-93","7")
test("41-29-07","35-95-88","8")
test("88-26-60","42-29-07","9")
test("18-40-85","34-40-91","10")
test("36-60-96","53-96-89","11")
test("51-39-02","44-98-69","12")
test("48-06-20","76-04-42","13")
test("85-29-18","26-50-93","14")
test("27-50-91","43-29-07","15")
test("57-06-20","48-60-91","16")
test("52-98-89","21-76-67","17")
test("67-12-40","45-80-92","18")
test("47-03-10","26-30-82","19")
test("74-28-06","21-86-37","20")
test("65-01-20","73-39-05","21")
test("17-72-86","36-50-94","22")
test("51-29-07","77-15-41","23")
test("33-98-39","82-16-02","24")
test("75-05-10","37-81-96","25")
test("72-58-06","48-80-96","26")
test("81-67-16","21-91-59","27")
test("13-96-57","24-96-79","28")
test("57-04-32","51-18-06","29")
test("88-03-52","28-41-86","30")
test("78-04-61","13-86-49","31")
test("58-12-20","27-50-85","32")
test("61-19-05","71-68-15","33")
test("63-29-16","18-31-83","34")
test("16-50-91","32-98-79","35")
test("82-17-03","38-40-81","36")
test("72-48-04","11-98-39","37")
test("77-05-10","28-50-62","38")
test("38-50-91","11-86-57","39")
test("87-05-10","13-97-69","40")
test("11-86-49","22-98-89","44")
test("11-97-69","12-86-67","46")
test("11-95-69","71-49-05","47")
test("28-31-92","13-98-79","48")

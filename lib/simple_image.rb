#
# Simple Image
#
# Copyright 2016, Adam Edwards
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class SimpleImage
  def initialize(is_sparse, width = 0, height = 0, default_color = 0)
    @width = width
    @height = height
    @sparseSize = 0
    @defaultColor = default_color
    @sparse = is_sparse
    @sparse_map = Hash.new
    @imageData = is_sparse ? [] : Array.new(width * height) { defaultColor }
  end

  def set_pixel(x, y, red, green, blue, alpha = 255)
    pixel_index = get_pixel_index(x, y)

    existing_sparse_offset = @sparse ? find_sparse_pixel(pixel_index) : nil
    image_offset = existing_sparse_offset.nil? ? new_sparse_pixel_offset : existing_sparse_offset

    color_offset = @sparse ? 1 : 0
    color = red + (green << 8) + (blue << 16) + (alpha << 24)

    @imageData[image_offset + color_offset] = color

    if @sparse && existing_sparse_offset.nil?
      add_sparse_pixel(pixel_index)
    end

    validate_color!(x, y, color)
  end

  def get_pixel(x, y)
    pixel_index = get_pixel_index(x, y)
    if @sparse
      existing_pixel = find_sparse_pixel(pixel_index)
      existing_pixel.nil? ? @defaultColor : @imageData[existing_pixel + 1]
    else
      @imageData[pixel_index]
    end
  end

  def get_hash
    {
      width: width,
      height: height,
      format: @sparse ? 1 : 0,
      sparseSize: sparseSize,
      defaultColor: defaultColor,
      imageData: imageData
    }
  end

  attr_reader :width
  attr_reader :height
  attr_reader :sparseSize
  attr_reader :imageData
  attr_reader :defaultColor

  private

  def get_pixel_index(x, y)
    if ( x < 0 || x >= width )
      raise "set_pixel: x coordinate value `#{x}` not in the range 0 to #{width - 1}"
    end

    if ( y < 0 || y >= height )
      raise "set_pixel: y coordinate value `#{y}` not in the range 0 to #{height - 1}"
    end

    y * @width + x
  end

  def new_sparse_pixel_offset
    @sparseSize * 2
  end

  def add_sparse_pixel(pixel_index)
    new_offset = new_sparse_pixel_offset
    @imageData[new_offset] = pixel_index
    @sparse_map[pixel_index] = new_offset
    @sparseSize += 1
  end

  def find_sparse_pixel(pixel_index)
    @sparse_map[pixel_index]
  end

  def validate_color!(x, y, color)
    newcolor = get_pixel(x, y)
    if newcolor != color
      raise "At #{x},#{y} the color shoud be #{color}, but #{newcolor} was returned"
    end
  end
end

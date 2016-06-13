#
# Circler -- a circle drawing test.
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

require_relative 'simple_image'
require_relative 'image_writer'

class Circler
  class Coordinate
    def initialize(x = 0, y = 0)
      @x = x
      @y = y
    end

    def set(x, y)
      @x = x
      @y = y
    end

    def copy(other)
      @x = other.x
      @y = other.y
    end

    attr_reader :x
    attr_reader :y
  end

  def initialize(radius)
    @radius = radius
    @image_data = nil
  end

  def get_image(sparse_image, default_color = 0)
    if @image_data.nil?
      image_data = SimpleImage.new(sparse_image, @radius * 2 + 1, @radius * 2 + 1, default_color)

      current = Coordinate.new(@radius, 0)
      below = Coordinate.new
      below_left = Coordinate.new

      while ( current.x > current.y )
        below.set(current.x, current.y + 1)
        below_left.set(current.x - 1, current.y + 1)
        closest = below

        distance_below = (Math.sqrt(below.x * below.x + below.y * below.y) - @radius).abs
        distance_below_left = (Math.sqrt(below_left.x * below_left.x + below_left.y * below_left.y) - @radius).abs

        closest = below_left if distance_below > distance_below_left

        current.copy(closest)

        image_data.set_pixel(@radius + current.x, @radius + current.y, 0, 0, 0)
        image_data.set_pixel(@radius + current.x, @radius - current.y, 0, 0, 255)
        image_data.set_pixel(@radius - current.x, @radius + current.y, 0, 255, 0)
        image_data.set_pixel(@radius - current.x, @radius - current.y, 0, 255, 255)

        image_data.set_pixel(@radius + current.y, @radius + current.x, 255, 0, 0)
        image_data.set_pixel(@radius + current.y, @radius - current.x, 255, 0, 255)
        image_data.set_pixel(@radius - current.y, @radius + current.x, 255, 255, 0)
        image_data.set_pixel(@radius - current.y, @radius - current.x, 128, 128, 128)
      end

      @image_data = image_data
    end

    @image_data
  end

  def self.get_boolean_argument(argument_name)
    found = ARGV.find do | argument |
      argument == argument_name
    end

    ! found.nil?
  end

  def self.get_argument(argument_name)
    found = nil
    found_index = nil
    for index in 0...ARGV.length do
      found_index = index if ARGV[index] == argument_name
    end
    if ! found_index.nil? && found_index < (ARGV.length - 1)
      found = ARGV[found_index + 1]
    end
    found_index.nil? ? nil : [found_index, found]
  end

  def self.print_usage
    puts "\nUsage:\n\tdrawtestcircle <radius> [--sparse] [--javascript | --binary-file <binary_output_file>]\n"
  end

  def self.get_arguments!
    valid_arguments = true

    arguments = {}

    if ARGV[0].nil? || ARGV.length < 1
      valid_arguments = false
    end

    valid_argument_count = 1

    if valid_arguments
      arguments[:radius] = ARGV[0].to_i
      arguments[:is_sparse] = get_boolean_argument('--sparse')
      arguments[:javascript] = get_boolean_argument('--javascript')

      binary_file_argument = get_argument('--binary-file')

      if binary_file_argument
        if arguments[:javascript]
          puts "\nERROR: --javascript may not be specified if --binary-file is specified."
          valid_arguments = false
        end
        if valid_arguments && binary_file_argument[1].nil?
          puts "\nERROR: The --binary-file argument was specified without a file name."
          valid_arguments = false
        else
          arguments[:binary_file] = binary_file_argument[1]
          valid_argument_count += 2
        end
      end
    end

    valid_argument_count += (arguments[:is_sparse] ? 1 : 0) + (arguments[:javascript] ? 1 : 0)

    if valid_argument_count != ARGV.length
      puts "\nERROR: 1 or more unrecognized arguments were specified"
      valid_arguments = false
    end

    if ! valid_arguments
      print_usage
      puts
      exit 1
    end

    arguments
  end

  def self.run
    arguments = get_arguments!

    radius = arguments[:radius]
    is_sparse = arguments[:is_sparse]
    javascript = arguments[:javascript]
    binary_file = arguments[:binary_file]

    circler = Circler.new(radius)
    image = circler.get_image(is_sparse)

    if binary_file.nil?
      puts ImageWriter.write_json_to_string(image, javascript)
    else
      file_length = ImageWriter.write_binary_file(image, binary_file)
      puts "BSON data of length #{file_length} output to `#{binary_file}`"
    end
  end
end

Circler.run


#
# Image Writer
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

require 'json'
require 'bson'

class ImageWriter
  def self.write_to_javascript_string(image)
    write_json_to_string(image.get_hash, true)
  end

  def self.write_binary_file(image, binary_file)
    image_data = image.get_hash.to_bson
    image_length = image_data.length
    File.binwrite(binary_file, image_data)
  end

  def self.write_json_to_string(image, javascript = false)
    image_json = image.get_hash.to_json
    javascript_start = javascript ? "var imageJSON = `" : ''
    javascript_end = javascript ? "`" : ''
    "#{javascript_start}#{image_json}#{javascript_end}"
  end
end

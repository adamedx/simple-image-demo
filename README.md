# Simple Image Demo
This repository demonstrates usage of an image format with the preliminary name *Simple Image*.

## Image format
The *Simple Image* format is an easy way to represent a two-dimensional image. It takes advantage of the widely utilized JSON serialization format, along with a binary analog BSON to enable generation of images on any platform without the need to understand more complicated binary image formats or identify libraries or other dependencies for manipulating such formats.

### Format Examples

#### Sparse example

```json
{
  "width": 7,
  "height": 7,
  "format": 1,
  "sparseSize": 12,
  "defaultColor": 0,
  "imageData": [
    34,
    4278190080,
    20,
    4294901760,
    28,
    4278255360,
    14,
    4294967040,
    46,
    4278190335
  ]
}
```

## Development

License and Authors
-------------------
Copyright:: Copyright (c) 2016 Adam Edwards

License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


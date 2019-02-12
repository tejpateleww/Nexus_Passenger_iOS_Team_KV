/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct PercelModel : Codable {
    
	var id : String?
	var name : String?
	var image : String?
	var status : String?
	var createdDate : String?

	enum CodingKeys: String, CodingKey {

		case id = "Id"
		case name = "Name"
		case image = "Image"
		case status = "Status"
		case createdDate = "CreatedDate"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decodeIfPresent(String.self, forKey: .name)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
        
        if let strId = try values.decodeIfPresent(String.self, forKey: .id) {
            id = strId
        }
        else {
            let intId = try values.decodeIfPresent(Int.self, forKey: .id)
            id = "\(intId ?? 0)"
        }
        
        if let strStatus = try values.decodeIfPresent(String.self, forKey: .status) {
            status = strStatus
        }
        else {
            let intStatus = try values.decodeIfPresent(Int.self, forKey: .status)
            status = "\(intStatus ?? 0)"
        }
        
        id = checkNil(param: id)
        name = checkNil(param: name)
        image = checkNil(param: image)
        status = checkNil(param: status)
        createdDate = checkNil(param: createdDate)
	}

}

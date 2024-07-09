//Created by Lugalu on 09/07/24.

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    public static let veproj = UTType(exportedAs:"com.lugalu.macve.veproj")
}


struct VEProjectType: Codable, FileDocument {
    static var readableContentTypes: [UTType] {
        get{
            return [.json]
        }
    }
    
    var value1: String = ""
    var value2: Int = 1
    
    init(){}
    
    init(withData data: Data) throws{
        let decoder = JSONDecoder()
        let result = try decoder.decode(VEProjectType.self, from: data)
        value1 = result.value1
        value2 = result.value2
    }

    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            let decoder = JSONDecoder()
            let result = try decoder.decode(VEProjectType.self, from: data)
            value1 = result.value1
            value2 = result.value2
            print(self)
            return
        }
        value1 = "alo"
        value2 = 10
        print(self)
    }
    
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        let result = try encoder.encode(self)
        let wrapper = FileWrapper(regularFileWithContents: result)
        wrapper.preferredFilename = "projectTest"
        return wrapper
    }
    
    
}

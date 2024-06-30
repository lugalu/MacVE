//Created by Lugalu on 30/06/24.

import SwiftUI
import UniformTypeIdentifiers

struct ProjectSelectorView: View {
    var body: some View {
        VStack{
            
        }
    }
}





#Preview {
    ProjectSelectorView()
}

//Attached to View
/*
 .fileImporter(isPresented: $isPublishing,
               allowedContentTypes: [.json]){ result in
     switch result {
     case .success(let resultURL):
         do {
             
             if resultURL.startAccessingSecurityScopedResource() {
                 defer{
                     resultURL.stopAccessingSecurityScopedResource()
                 }
                 throw NSError(domain: "", code: 1)
                 let readTest = try Data(contentsOf: resultURL)
                 let newTest = try Test(withData: readTest)
                 print("secure", readTest, newTest)
                 return
             }
             //MARK: Need to inform that an error occured!

         } catch {
             print(error.localizedDescription)
         }
     case .failure(let failure):
         print("hey, \(failure)")

     }
     
 }
 */

struct Test: Codable, FileDocument {
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
        let result = try decoder.decode(Test.self, from: data)
        value1 = result.value1
        value2 = result.value2
    }

    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            let decoder = JSONDecoder()
            let result = try decoder.decode(Test.self, from: data)
            value1 = result.value1
            value2 = result.value2
            return
        }
        value1 = "alo"
        value2 = 10
    }
    
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        let result = try encoder.encode(self)
        let wrapper = FileWrapper(regularFileWithContents: result)
        wrapper.preferredFilename = "projectTest"
        return wrapper
    }
    
    
}

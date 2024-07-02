//Created by Lugalu on 30/06/24.

import SwiftUI
import UniformTypeIdentifiers

struct ProjectSelectorView: View {
    var body: some View {
        VStack(alignment:.leading, spacing: 16) {
            
            Text("Welcome To MacVE!")
                .font(.largeTitle)
            
            
            HStack(spacing: 8) {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Label("Create new Project", systemImage: "plus")
                        .labelStyle(RightHandedIconLabelStyle())
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                })
                .buttonStyle(.borderedProminent)
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Label("Open from disk", systemImage: "folder")
                        .labelStyle(RightHandedIconLabelStyle())
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                })
                .buttonStyle(.borderedProminent)

            }
            .padding(.leading, 8)
            
            
            Text("Recent Projects")
                .font(.title)
                .padding(.leading, 8)

            
            HStack {
                ProjectCard()
            }
            .padding(.leading, 16)
            
            
        }
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

struct ProjectCard: View {
    var body: some View {
        Image(systemName: "pencil")
            .resizable()
            .scaledToFit()
            .frame(width: 136, height: 204)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .fixedSize()
            .overlay(alignment: .bottom){
                ZStack(alignment: .bottomLeading){
                    LinearGradient(stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .clear, location: 0.6),
                        .init(color: .black.opacity(0.8), location: 1)
                    ],
                                    startPoint: .top,
                                    endPoint: .bottom)
                    .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 10,bottomTrailingRadius: 10))
                
                    VStack(alignment: .leading, spacing: 4){
                        Text("Title")
                        Text("Last Access:")
                        Text("Duration:")
                    }
                    .padding([.bottom,.leading], 8)
                }
            }
            .clipped()
    }
}



struct RightHandedIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack{
            configuration.title
            configuration.icon
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

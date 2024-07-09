//Created by Lugalu on 30/06/24.

import SwiftUI

struct ProjectSelectorView<T: ProjectSelectorModelProtocol>: View {
    
    @EnvironmentObject var viewModel: T
    
    var body: some View {
        VStack(alignment:.leading, spacing: 16) {
            
            Text("Welcome To MacVE!")
                .font(.largeTitle)
            
        
                HStack(spacing: 8) {
                    Button(action: {
                        
                    }, label: {
                        Label("Create New Project", systemImage: "plus")
                            .labelStyle(.rightHanded)
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .padding(5)
                    })
                    .buttonStyle(.borderedProminent)
                    
                    Button(action: {
                        viewModel.isOpeningFile = true
                    }, label: {
                        Label("Open From Disk", systemImage: "folder.fill")
                            .labelStyle(.rightHanded)
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .padding(5)
                        
                    })
                    .buttonStyle(.borderedProminent)
                    .fileImporter(isPresented: $viewModel.isOpeningFile,
                                  allowedContentTypes: [.veproj]) { result in
                        viewModel.handleFileOpening(with: result)
                    }
                    
                }
                
                
                Text("Recent Projects")
                    .font(.title)
                
                HStack(alignment: .center, spacing: 32){
                    ProjectCard()
                    ProjectCard()
                    ProjectCard()
                    ProjectCard()
                    
                }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .fixedSize()
    }
}

struct ProjectCard: View {
    var body: some View {
        Image("Bird")
            .resizable()
            .frame(width: 140, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
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





#Preview {
    ProjectSelectorView<ProjectSelectorModel>()
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



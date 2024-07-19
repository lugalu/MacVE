//Created by Lugalu on 30/06/24.

import SwiftUI
import AppKit

struct ProjectSelectorView<T: ProjectSelectorModelProtocol>: View {
    @Environment(\.openWindow) private var openWindow
    @EnvironmentObject var viewModel: T
    
    @State var test: [Int] = Array(0..<10)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Group{
                Text("Welcome To MacVE!")
                    .font(.largeTitle)
                    .padding(.top, 16)
                
                Button(action: {
                    viewModel.isCreatingProject = true
                    //  viewModel.createNewProject(withTitle: )
                }, label: {
                    Label("Create New Project", systemImage: "plus")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .padding(4)
                        .frame(alignment: .leading)
                    
                })
                .buttonStyle(.borderedProminent)
                
                List($test, id: \.self, editActions: .delete){ idx in
                    ProjectCell(title: "A TITLE NUMBER: \(idx.wrappedValue)"){
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: -10))
                    .contextMenu{
                        Button(
                            action: {
                                test.remove(at: idx.wrappedValue)
                            }, label: {
                                Text("delete")
                            })
                    }
                }
                .clipShape(.rect(cornerRadius: 4))
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 16)
        }
        .frame(width: 350, height: 400)
        .fixedSize()
        
        .sheet(isPresented: $viewModel.isCreatingProject){
            Form {
                Section{
                    TextField(text: $viewModel.title, prompt: Text("Required")) {
                        Text("Project Title")
                    }
                    
                    Button("Done"){
                        guard let proj = viewModel.createNewProject(withTitle: viewModel.title) else {
                            viewModel.isCreatingProject = false
                            viewModel.error = true
                            return
                        }
                        openWindow(value: proj.id)
                    }
                    .disabled(viewModel.title.isEmpty || viewModel.title.count <= 2)
                }
            }
            .formStyle(.columns)
            .padding(16)
            .frame(width: 250, height: 100)
            .fixedSize()
        }
        
        .alert("Error Creating Project", isPresented: $viewModel.error){
            Button("Ok"){
                viewModel.error = false
                viewModel.isCreatingProject = false
            }

        } message: {
            Text("an error Occured trying to create the project, please try again.")
        }
    }
    
    
    func removeRow(at offsets: IndexSet){
        print(offsets)
    }

}

struct ProjectCell: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        
        
        Button(action: {
            action()
        }, label: {
            HStack(spacing: 4){
                Image(systemName: "movieclapper")
                    .font(.system(size: 20))
                VStack(alignment: .leading) {
                    Text(title)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text("Last Access: \(Date().formatted(date: .abbreviated, time: .shortened)) ")
                }
                Spacer()
            }
            .padding([.horizontal,.vertical], 8)
            .background(Color(cgColor: NSColor.systemFill.cgColor))
        })
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    

    }
}





#Preview {
//    var model = ProjectSelectorModel()
//    model.isCreatingProject = true
    ProjectSelectorView<ProjectSelectorModel>()
        .environment(ProjectSelectorModel())
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



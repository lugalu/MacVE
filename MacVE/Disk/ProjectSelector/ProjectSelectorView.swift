//Created by Lugalu on 30/06/24.

import SwiftUI
import AppKit

struct ProjectSelectorView<T: ProjectSelectorModelProtocol>: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @EnvironmentObject var viewModel: T

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Group {
                Text("Welcome To MacVE!")
                    .font(.largeTitle)
                    .padding(.top, 16)
                    .onAppear {
                        viewModel.fetchProjects()
                    }
                
                Button(action: {
                    viewModel.isCreatingProject = true
                }, label: {
                    Label("Create New Project", systemImage: "plus")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .padding(4)
                        .frame(alignment: .leading)
                    
                })
                .buttonStyle(.borderedProminent)
                
                ListProjects()
                
            }
            .padding(.horizontal, 16)
            
        }
        .frame(width: 350, height: 400)
        .fixedSize()
        
        .sheet(isPresented: $viewModel.isCreatingProject) {
            sheetView()
        }
        
        .alert("Error Creating Project", isPresented: $viewModel.error) {
            Button("Ok"){
                viewModel.error = false
                viewModel.isCreatingProject = false
            }
        } message: {
            Text("an error Occured trying to create the project, please try again.")
        }
    }
    
    private func ListProjects() -> some View {
        return List($viewModel.projects, id: \.id, editActions: .delete){ project in
            
            ProjectCell(project: project.wrappedValue) {
                let project = project.wrappedValue
                if let id = project.id {
                    openWindow(value: project.id)
                    dismissWindow()
                }
            }
            .listRowInsets(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: -10))
            .contextMenu{
                Button("Delete"){
                    if let id = project.wrappedValue.id {
                        viewModel.delete(withID: id)
                    }
                }
            }
        }
        .clipShape(.rect(cornerRadius: 4))
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .padding(.bottom, 16)
    }
    
    private func sheetView() -> some View {
        return Form {
            Section{
                TextField(text: $viewModel.title, prompt: Text("Required")) {
                    Text("Project Title")
                }
                
                Button("Done"){
                    viewModel.isCreatingProject = false
                    
                    guard let proj = viewModel.createNewProject(withTitle: viewModel.title) else {
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
}

struct ProjectCell: View {
    var project: Project
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack(spacing: 4){
                Image(systemName: "movieclapper")
                    .font(.system(size: 20))
                VStack(alignment: .leading) {
                    Text(project.title ?? "Error")
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text("Last Access: \(getFormattedDate())")
                }
                Spacer()
            }
            .padding([.horizontal,.vertical], 8)
            .background(Color(cgColor: NSColor.systemFill.cgColor))
        })
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    

    }
    
    func getFormattedDate() -> String {
        guard let lastAccess = project.lastAccess else {
            return "ERROR"
        }
        return lastAccess.formatted(date: .abbreviated, time: .shortened)
    }
    
}





#Preview {
    ProjectSelectorView<ProjectSelectorModel>()
        .environment(ProjectSelectorModel())
}

//Created by Lugalu on 02/08/24.

import SwiftUI

struct EditorView: View {
    @ObservedObject var viewModel: EditorViewModel
    
    var body: some View {
        VStack(spacing: 16){
            HStack(spacing: 16){
                Rectangle()
                    .fill(.black)
                    .frame(maxWidth: .infinity)
                PlaybackView<PlaybackModel>()
                    .environmentObject(PlaybackModel(database: viewModel.persistance, id: viewModel.projectID))
            }
            Rectangle()
                .fill(.black)
                .frame(maxWidth: .infinity)
        }
        .padding(16)
    }
}

class EditorViewModel: ObservableObject {
    @Published var persistance: PersistenceController
    @Published var projectID: UUID
    @Published var project: Project
    
    init?(persistance: PersistenceController, projectID: UUID) {
        self.persistance = persistance
        self.projectID = projectID
        
        guard let project = try? persistance.fetch(projectID) else {
            
            return nil
        }
        self.project = project
    }
    
    
}

#Preview {
    EditorView(viewModel: 
                EditorViewModel(persistance: PersistenceController.preview,
                                projectID: try! PersistenceController
                                    .preview
                                    .fetch()
                                    .first!
                                    .id!
                               )!)
}

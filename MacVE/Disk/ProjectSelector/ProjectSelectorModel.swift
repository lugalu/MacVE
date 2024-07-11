//Created by Lugalu on 09/07/24.

import SwiftUI

@MainActor
protocol ProjectSelectorModelProtocol: ObservableObject {
    var isOpeningFile: Bool { get set }
    var isCreatingProject: Bool { get set }
    
    func handleFileOpening(with: Result<URL, any Error>) -> VEProjectType?
    //func createNewProject(at: URL)
    
}


class ProjectSelectorModel: ObservableObject, Observable, ProjectSelectorModelProtocol {
    @Published var isOpeningFile: Bool = false
    @Published var isCreatingProject: Bool = true
    
    
    
    
    
    func handleFileOpening(with result: Result<URL, any Error>) -> VEProjectType? {
        switch result {
        case .success(let resultURL):
            do {
                if resultURL.startAccessingSecurityScopedResource() {
                    defer{
                        resultURL.stopAccessingSecurityScopedResource()
                    }
                    let diskData = try Data(contentsOf: resultURL)
                    guard let project = try VEProjectType(withData: diskData) else {
                        fatalError("ops")
                    }
                
                    return project
                }
                //MARK: Need to inform that an error occured!

            } catch {
                print(error.localizedDescription)
                return nil
            }
        case .failure(let failure):
            print("hey, \(failure)")
            return nil

        }
        return nil
    }
}

//Created by Lugalu on 09/07/24.

import SwiftUI

@MainActor
protocol ProjectSelectorModelProtocol: ObservableObject {
    var isOpeningFile: Bool { get set }
    var isCreatingProject: Bool { get set }
    
    func handleFileOpening(with: Result<URL, any Error>)
    //func createNewProject(at: URL)
    
}


class ProjectSelectorModel: ObservableObject, Observable, ProjectSelectorModelProtocol {
    @Published var isOpeningFile: Bool = false
    @Published var isCreatingProject: Bool = true
    
    
    
    
    
    func handleFileOpening(with result: Result<URL, any Error>) {
        switch result {
        case .success(let resultURL):
            print("hey!")
            do {
                if resultURL.startAccessingSecurityScopedResource() {
                    defer{
                        resultURL.stopAccessingSecurityScopedResource()
                    }
                    let readTest = try Data(contentsOf: resultURL)
                    let newTest = try VEProjectType(withData: readTest)
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
}

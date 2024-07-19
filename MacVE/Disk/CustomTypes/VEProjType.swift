//Created by Lugalu on 09/07/24.

import SwiftUI
import UniformTypeIdentifiers
import AVKit

extension UTType {
    public static let veproj = UTType(exportedAs:"com.lugalu.macve.veproj")
}

enum VEProjectError: LocalizedError {
    case accessError
    case writeError
    case decodeError
    case versionError
    
    var errorDescription: String? {
        return switch self {
        case .accessError:
            "Couldn't access the file on disk, please check if the app is allowed to read from disk in system settings."
        case .writeError:
            "Couldn't write to disk, please check if the app is allowed to write to disk in system settings."
        case .decodeError:
            "The provided file contains a critical error or corruption."
        case .versionError:
            "The provided file is from a future version or is missing the version tag."
        }
    }
}

class VEProjectType: Codable, FileDocument {
    static var readableContentTypes: [UTType] {
        get{
            return [.json, .veproj]
        }
    }
    
    var version: String = ""
    var title: String = ""
    var tracks: Array<trackInfo> = []
    
    class trackInfo: Codable {
        var id: Int
        var type: String
        var start: TimeInterval
        var end: TimeInterval
        var isEnabled: Bool
        var content: Data
    }
    
    init(){}
    
    init?(withData data: Data) throws{
        let decoder = JSONDecoder()
        let result = try decoder.decode(VEProjectType.self, from: data)
        commonInit(result)
    }

    required init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            let decoder = JSONDecoder()
            let result = try decoder.decode(VEProjectType.self, from: data)
            commonInit(result)
            return
        }
        throw VEProjectError.accessError
    }
    
    private func commonInit(_ result: VEProjectType){
        version = result.version
        title = result.version
        tracks = result.tracks
    }
    
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        let result = try encoder.encode(self)
        let wrapper = FileWrapper(regularFileWithContents: result)
        wrapper.preferredFilename = "projectTest"
        return wrapper
    }
    
    
}

@objc(CompositionTransformer)
class CompositionTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let composition = value as? AVMutableComposition else {
            return nil
        }
        
        do{
           return try NSKeyedArchiver.archivedData(withRootObject: composition, requiringSecureCoding: true)
        }catch{
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            return nil
        }
        do {
        //    let test = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [AVMutableComposition.self], from: data)
            guard let comp = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? AVMutableComposition
            else {
                return nil
            }
            
            return comp
        }catch {
            return nil
        }
    }
    
}

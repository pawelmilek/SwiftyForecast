import Foundation

enum PlistFileLoader {
    static func loadFile<T>(with name: String) throws -> T {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist"),
              let plistXML = FileManager.default.contents(atPath: path) else {
            throw FileLoaderError.fileNotFound(name: name)
        }

        if let reslut = try? PropertyListSerialization.propertyList(from: plistXML,
                                                                    options: .mutableContainersAndLeaves,
                                                                    format: nil) as? T {
            return reslut
        } else {
            throw FileLoaderError.incorrectFormat
        }
    }

    static func loadFile<T: Decodable>(with name: String, model: T.Type) throws -> T {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist"),
              let plistXML = FileManager.default.contents(atPath: path) else {
            throw FileLoaderError.fileNotFound(name: name)
        }

        if let reslut = try? PropertyListDecoder().decode(model, from: plistXML) {
            return reslut
        } else {
            throw FileLoaderError.incorrectFormat
        }
    }
}

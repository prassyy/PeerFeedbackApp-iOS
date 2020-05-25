//
//  JsonFileManager.swift
//  PeerFeedbackApp
//
//  Created by Prassyy on 04/08/19.
//  Copyright © 2019 prassi. All rights reserved.
//

import Foundation

class JsonFileManager {
    func fetchJsonObject<T: Decodable>(from fileName: String, ofType type: T.Type) -> T? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return try JSONDecoder().decode(type, from: data)
            } catch {
                print(error)
                return nil
            }
        }
        return nil
    }
}

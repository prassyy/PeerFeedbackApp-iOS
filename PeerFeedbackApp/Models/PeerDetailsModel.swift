//
//  PeerDetailsModel.swift
//  PeerFeedbackApp
//
//  Created by fordlabs on 24/09/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import Foundation

enum Role: String, Decodable {
    case avengers
    case justiceLeague
    case pokemon
    
    func displayString() -> String {
        switch self {
        case .avengers: return "Avengers"
        case .justiceLeague: return "Justice League"
        case .pokemon: return "Pokémon"
        }
    }
}

struct PeerDetailsModel: Decodable {
    var role: Role?
    var peerName: String?
    var emailId: String?
    
    var isValid: Bool {
        return role.exists && peerName.exists && emailId.exists
    }
}

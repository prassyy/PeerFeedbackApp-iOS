//
//  PListDataManagerSpec.swift
//  PeerFeedbackAppTests
//
//  Created by Prassyy on 24/09/18.
//  Copyright © 2018 prassi. All rights reserved.
//

import XCTest

@testable import PeerFeedbackApp

class PListDataManagerSpec: XCTestCase {
    var subject: PListDataManager!
    let testPeers = [ PeerDetailsModel(role: "Android Developer", peerName: "Harshith", emailId: "pharshit@ford.com"),
                      PeerDetailsModel(role: "Android Developer", peerName: "Mukesh", emailId: "bmukesh@ford.com"),
                      PeerDetailsModel(role: "iOS Developer", peerName: "Karpagam", emailId: "ekarpaga@ford.com"),
                      PeerDetailsModel(role: "iOS Developer", peerName: "Prasanna", emailId: "kprasan6@ford.com"),
                      PeerDetailsModel(role: "iOS Developer", peerName: "Elumalai", emailId: "relumal2@ford.com")]
    
    override func setUp() {
        subject = PListDataManager(bundle: Bundle(for: type(of: self)))
    }
    
    func test_readsFromPlistAndReturnsPeerDetailsModelForGivenRole() {
        let expectedAndroidPeers = getTestPeers(for: "Android Developer")
        let expectediOSPeers = getTestPeers(for: "iOS Developer")

        let androidPeersList = subject.fetchPeerNameList(for: "Android Developer")
        XCTAssertEqual(androidPeersList.count, 2)
        for (index, actualPeer) in androidPeersList.enumerated() {
            XCTAssert(actualPeer.equals(peer: expectedAndroidPeers[index]))
        }

        let iOSPeersList = subject.fetchPeerNameList(for: "iOS Developer")
        XCTAssertEqual(iOSPeersList.count, 3)
        for (index, actualPeer) in iOSPeersList.enumerated() {
            XCTAssert(actualPeer.equals(peer: expectediOSPeers[index]))
        }
    }
    
    private func getTestPeers(for role: String) -> [PeerDetailsModel] {
        return testPeers.filter { $0.role == role }
    }
}

extension PeerDetailsModel {

    func equals(peer: PeerDetailsModel) -> Bool {
        return self.peerName == peer.peerName &&
                self.role == peer.role &&
                self.emailId == peer.emailId
    }
}

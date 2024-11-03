//
//  CHGameContext.swift
//  cheesehunt
//
//  Created by Vahan Gevorgyan on 10/27/24.
//


import GameplayKit
import SwiftUI

class CHGameContext {
    private(set) var scene: CHGameScene!
    private(set) var stateMachine: GKStateMachine?
    
    var layoutInfo: CHLayoutInfo
    let gameInfo: CHGameInfo
    
    init() {
        self.layoutInfo = CHLayoutInfo()
        self.gameInfo = CHGameInfo()
        self.scene = CHGameScene(context: self, size: UIScreen.main.bounds.size)
        configureStates()
    }
    
    func configureStates() {
        stateMachine = GKStateMachine(
            states: [
                CHStartState(scene: scene, context: self),
                CHGameState(scene: scene, context: self)
            ]
        )
    }
    
}

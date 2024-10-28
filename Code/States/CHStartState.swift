//
//  CHStartState.swift
//  cheesehunt
//
//  Created by Vahan Gevorgyan on 10/27/24.
//

import GameplayKit
import SpriteKit

class CHStartState: GKState {
    weak var scene: CHGameScene?
    weak var context: CHGameContext?
    
    init(scene: CHGameScene, context: CHGameContext) {
        self.scene = scene
        self.context = context
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func didEnter(from previousState: GKState?) {
        print("did enter StartState")
    }
}


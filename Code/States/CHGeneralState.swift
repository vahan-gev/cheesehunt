//
//  CHGeneralState.swift
//  cheesehunt
//
//  Created by Vahan Gevorgyan on 11/3/24.
//

import GameplayKit
import SpriteKit

class CHGeneralState: GKState {
    unowned let gameScene: CHGameScene
    unowned let context: CHGameContext
    init(gameScene: CHGameScene, context: CHGameContext) {
        self.gameScene = gameScene
        self.context = context
        super.init()
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {   }
}

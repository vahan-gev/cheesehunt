//
//  CHGameState.swift
//  cheesehunt
//
//  Created by Vahan Gevorgyan on 11/3/24.
//

import GameplayKit
import SpriteKit

class CHGameState: CHGeneralState {
    let generator = GridGenerator()
    init(scene: CHGameScene, context: CHGameContext) {
        super.init(gameScene: scene, context: context)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func didEnter(from previousState: GKState?) {
        print("did enter GameState")
        let grid = generator.generateGrid()
        generator.printGrid(grid)
        print("===================")
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
}

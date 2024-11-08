//
//  CHEndState.swift
//  cheesehunt
//
//  Created by Vahan Gevorgyan on 11/6/24.
//

import GameplayKit
import SpriteKit

class CHEndState: CHGeneralState {
    let menuNode = SKNode()
    let replay = SKSpriteNode(imageNamed: "reload_button")
    let home = SKSpriteNode(imageNamed: "home_button")
    
    init(scene: CHGameScene, context: CHGameContext) {

        super.init(gameScene: scene, context: context)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func didEnter(from previousState: GKState?) {
        print("did enter EndState")
        setupUI()
    }
    
    
    override func willExit(to nextState: GKState) {
        self.menuNode.removeAllActions()
        self.menuNode.run(SKAction.fadeOut(withDuration: 0.1)) {
            self.menuNode.removeAllChildren()
            self.menuNode.removeFromParent()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: menuNode)
        
        if replay.contains(touchLocation) {
            gameScene.context.stateMachine?.enter(CHGameState.self)
        } else if home.contains(touchLocation) {
            gameScene.context.stateMachine?.enter(CHStartState.self)
        }
    }
}

extension CHEndState {
    func setupUI() {
        self.menuNode.run(SKAction.fadeIn(withDuration: 0.2))
        self.replay.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY + 200)
        self.replay.size = CGSize(width: 150, height: 150)
        self.replay.zPosition = 1
        
        self.home.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)
        self.home.size = CGSize(width: 150, height: 150)
        self.home.zPosition = 1
        
        self.menuNode.addChild(self.replay)
        self.menuNode.addChild(self.home)

        
        self.gameScene.addChild(self.menuNode)
    }
}

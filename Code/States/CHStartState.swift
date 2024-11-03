//
//  CHStartState.swift
//  cheesehunt
//
//  Created by Vahan Gevorgyan on 10/27/24.
//

import GameplayKit
import SpriteKit

class CHStartState: CHGeneralState {
    private var coolDownDuration: TimeInterval = 0.7
    
    let menuNode = SKNode()
    let buttonNode = SKSpriteNode(imageNamed: "play")
    let mundurik = SKSpriteNode(imageNamed: "mundurik")
    
    init(scene: CHGameScene, context: CHGameContext) {

        super.init(gameScene: scene, context: context)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func didEnter(from previousState: GKState?) {
        print("did enter StartState")
        setupUI()
    }
    
    override func willExit(to nextState: GKState) {
        menuNode.removeAllActions()
        menuNode.run(SKAction.fadeOut(withDuration: 0.3)) {
            self.menuNode.removeAllChildren()
            self.menuNode.removeFromParent()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: gameScene)
        
        if buttonNode.contains(touchLocation) {
            gameScene.context.stateMachine?.enter(CHGameState.self)
        } else {
            handleTap(touches)
        }
    }
}

// MARK: Setup
extension CHStartState {
    func setupUI() {
        buttonNode.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)
        buttonNode.size = CGSize(width: 100, height: 100)
        buttonNode.zPosition = 1
        menuNode.addChild(buttonNode)

        mundurik.size = CGSize(width: 365, height: 332.56)
        mundurik.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.minY + 50)
        menuNode.addChild(mundurik)
        gameScene.addChild(menuNode)
    }
}

// MARK: Helpers
extension CHStartState {
    func handleTap(_ touches: Set<UITouch>) {
        print("tapping")
        gameScene.incrementScore()
    }
    
    func animateLabel(_ label: SKLabelNode) {
        let fadeIn = SKAction.fadeIn(withDuration: coolDownDuration * 2/3)
        let fadeOut = SKAction.fadeOut(withDuration: coolDownDuration * 1/3)
        let sequence = SKAction.sequence([fadeIn, fadeOut])
        label.run(sequence)
    }
}


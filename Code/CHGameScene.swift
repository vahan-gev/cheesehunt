//
//  CHGameScene.swift
//  cheesehunt
//
//  Created by Vahan Gevorgyan on 10/27/24.
//

import SpriteKit
import GameplayKit

class CHGameScene: SKScene {
    unowned let context: CHGameContext
    var gameInfo: CHGameInfo? { context.gameInfo }
    var gameCamera: SKCameraNode?
    let scoreLabel = SKLabelNode()
    private var isDead = false
    
    init(context: CHGameContext, size: CGSize) {
        self.context = context
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.setupScene()
        context.stateMachine?.enter(CHStartState.self)
    }
}

// MARK: Setup
extension CHGameScene {
    func setupScene() {
        self.setupCamera()
        self.backgroundColor = UIColor(red: 1, green: (235/255), blue: (216/255), alpha: 1.0)
    }
    
    private func setupCamera() {
        gameCamera = SKCameraNode()
        if let gameCamera = gameCamera {
            gameCamera.position = CGPoint(x: size.width / 2, y: size.height / 2)
            self.camera = gameCamera
            addChild(gameCamera)
            
            scoreLabel.position = CGPoint(x: size.width * 0.4, y: size.height * 0.4)
            scoreLabel.fontColor = .black
            scoreLabel.fontSize = 50
            scoreLabel.zPosition = 1000
            scoreLabel.text = "\(gameInfo?.score ?? 0)"
            scoreLabel.alpha = 1.0
            gameCamera.addChild(scoreLabel)
        }
    }
}


// MARK: Helpers
extension CHGameScene {
    func reset() {
        isDead = false
        
        gameCamera?.position = CGPoint(x: size.width / 2, y: size.height / 2)

        gameInfo?.reset()
        scoreLabel.text = "\(gameInfo?.score ?? 0)"
        scoreLabel.alpha = 1.0
    }
    
    func updateScore() {
        scoreLabel.text = "\(gameInfo?.score ?? 0)"
    }
    
    func incrementScore() {
        gameInfo?.score += 1
        scoreLabel.text = "\(gameInfo?.score ?? 0)"
    }
    
    override func update(_ currentTime: TimeInterval) {
        context.stateMachine?.update(deltaTime: currentTime)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let state = context.stateMachine?.currentState as? CHGeneralState {
            state.touchesBegan(touches, with: event)
        }
    }
}

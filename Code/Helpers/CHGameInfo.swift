//
//  CHGameInfo.swift
//  cheesehunt
//
//  Created by Vahan Gevorgyan on 10/27/24.
//

import Foundation

class CHGameInfo {
    var score: Int
    var lives: Int
    
    init() {
        score = 0
        lives = 3
    }
    
    func reset() {
        score = 0
        lives = 3
    }
    
    func incrementScore(by amount: Int) {
        score = score + amount
    }
    
    func decrementLives(by amount: Int) {
        lives = lives - amount
    }
}

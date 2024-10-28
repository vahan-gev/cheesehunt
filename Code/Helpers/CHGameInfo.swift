//
//  CHGameInfo.swift
//  cheesehunt
//
//  Created by Vahan Gevorgyan on 10/27/24.
//

import Foundation

class CHGameInfo {
    var score: Int
    
    init() {
        score = 0
    }
    
    func reset() {
        score = 0
    }
    
    func incrementScore(by amount: Int) {
        score = score + amount
    }
}

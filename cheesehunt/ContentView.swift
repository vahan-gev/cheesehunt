//
//  ContentView.swift
//  cheesehunt
//
//  Created by Vahan Gevorgyan on 10/27/24.
//

import GameplayKit
import SpriteKit
import SwiftUI

struct ContentView: View {
    
    let context = CHGameContext()
    
    var body: some View {
        ZStack {
            SpriteView(scene: context.scene, debugOptions: [])
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)
        }
        .statusBarHidden()
    }
}

//#Preview {
//    ContentView()
//}
    

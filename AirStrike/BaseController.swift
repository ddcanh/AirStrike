//
//  BaseController.swift
//  AirStrike
//
//  Created by Enrik on 9/23/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import SpriteKit

class BaseController {
    
    internal let view: View
    init(view: View) {
        self.view = view
    }
    
    internal func configurePhysics() {
    }
    
    func setup(parent: SKNode) {
    }
    
    func moveTo(position: CGPoint) {
        self.view.position = position
    }
    
    func moveBy(vector: CGPoint) {
        self.view.position = self.view.position.add(vector)
    }
}

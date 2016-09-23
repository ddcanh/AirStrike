//
//  Constants.swift
//  AirStrike
//
//  Created by Enrik on 9/23/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import Foundation

let PHYSICS_MASK_ENEMY = UInt32(1 << 0) // 1
let PHYSICS_MASK_ENEMY_BULLET = UInt32(1 << 1) // 2
let PHYSICS_MASK_PLAYER_BULLET = UInt32(1 << 2) // 4
let PHYSICS_MASK_PLAYER = UInt32(1 << 3) // 8
let PHYSICS_MASK_POWERUP = UInt32(1 << 4)


let SINGLE_BULLET_TYPE = 1
let DOUBLE_BULLET_TYPE = 2
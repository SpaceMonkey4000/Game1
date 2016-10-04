//
//  Drone.swift
//  Game1
//
//  Created by Drew Olbrich on 10/3/16.
//  Copyright © 2016 Retroactive Fiasco. All rights reserved.
//

import Foundation
import SpriteKit

class Drone {

    let spriteNode = SKSpriteNode(imageNamed: "red_drone")

    var shootingTimer: Timer?

    // How often to shoot, in seconds.
    let shootingDelay = 1.0

    init(firstWaitDuration: TimeInterval, nextWaitDuration: TimeInterval, teleportDuration: TimeInterval) {
        // Set initial drone position.
        spriteNode.position = randomDronePosition()

        // Make the drone move randomly around the screen.
        runDroneActions(spriteNode: spriteNode, waitDuration: firstWaitDuration, nextWaitDuration: nextWaitDuration, teleportDuration: teleportDuration)

        delay(fmod(firstWaitDuration, shootingDelay)) {
            self.shootingTimer = Timer.scheduledTimer(withTimeInterval: self.shootingDelay, repeats: true, block: { (Timer) in
                BulletManager.sharedManager.shootDroneBullet(from: self.spriteNode.position, to: CGPoint(x: 0.0, y: -0.44*screenHeight))
            })
        }
    }

    deinit {
        spriteNode.removeFromParent()
        shootingTimer?.invalidate()
    }

    func runDroneActions(spriteNode: SKNode, waitDuration: TimeInterval, nextWaitDuration: TimeInterval, teleportDuration: TimeInterval) {
        let waitAction = SKAction.wait(forDuration: waitDuration)
        let moveAction = SKAction.move(to: randomDronePosition(), duration: teleportDuration)

        // This makes the drone accelerate a little when it starts moving, and decelerate a little
        // before it stops moving. If you don't add this line, the drone will move at a constant rate.
        moveAction.timingMode = SKActionTimingMode.easeInEaseOut

        // Make a sequence of the wait and move actions.
        let actionSequence = SKAction.sequence([waitAction, moveAction])

        // Make the drone run the sequence of actions.
        spriteNode.run(actionSequence) {
            // When the sequence of actions finishes, run a new sequence of drone actions.
            self.runDroneActions(spriteNode: spriteNode, waitDuration: nextWaitDuration, nextWaitDuration: nextWaitDuration, teleportDuration: teleportDuration)
        }
    }

    func randomDronePosition() -> CGPoint {
        // random X of drone.
        let droneXspawn = random(min: -0.45, max: 0.45)
        // random Y of the drone.
        let droneYspawn = random(min: -0.2, max: 0.45)

        return CGPoint(x: droneXspawn*screenHeight, y: droneYspawn*screenHeight)
    }

}

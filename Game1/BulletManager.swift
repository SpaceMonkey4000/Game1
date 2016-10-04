//
//  BulletManager.swift
//  Game1
//
//  Created by Drew Olbrich on 10/3/16.
//  Copyright © 2016 Retroactive Fiasco. All rights reserved.
//

import SpriteKit

class BulletManager {

    static let sharedManager = BulletManager()

    var scene: SKScene?

    func shootPlayerBullet(from fromPosition: CGPoint, to toPosition: CGPoint) {
        shootBullet(from: fromPosition, to: toPosition, imageNamed: "playerball")
    }

    func shootDroneBullet(from fromPosition: CGPoint, to toPosition: CGPoint) {
        shootBullet(from: fromPosition, to: toPosition, imageNamed: "droneball")
    }

    private func shootBullet(from fromPosition: CGPoint, to toPosition: CGPoint, imageNamed imageName: String) {
        assert(scene != nil)
        
        let bulletNode = SKSpriteNode(imageNamed: imageName)
        bulletNode.setScale(1.5)
        scene!.addChild(bulletNode)
        bulletNode.position = fromPosition

        bulletNode.zPosition = 75.0

        // The direction we should fire the bullet.
        var direction = CGPoint(x: toPosition.x - fromPosition.x, y: toPosition.y - fromPosition.y)

        // Set the length of the direction vector to 1.
        let length = sqrt(direction.x*direction.x + direction.y*direction.y)
        direction.x /= length
        direction.y /= length

        // The distance that the bullet will travel before stopping. This is 50% more than
        // the width of the screen so it'll always be a point off the edge of the screen.
        let distance = CGFloat(screenWidth*1.5)

        // The end point of the bullet along its path before we remove it from the scene.
        let endPoint = CGPoint(x: fromPosition.x + distance*direction.x, y: fromPosition.y + distance*direction.y)

        // Move the bullet.
        let moveAction = SKAction.move(to: endPoint, duration: 1.45)
        bulletNode.run(moveAction) {
            bulletNode.removeFromParent()
        }
        
    }
}

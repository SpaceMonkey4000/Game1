
import SpriteKit

class GameScene: SKScene {
    var spaceshipNode = SKSpriteNode(imageNamed: "Spaceship")

    // The size of the iPad screen.
    let screenWidth = 1024.0
    let screenHeight = 768.0

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)

        // Called before the game starts.

        // Add the spaceship to the scene.
        self.addChild(spaceshipNode)

        // The center of the screen is 0, 0.
        // The left side of the screen is -0.5*screenWidth.
        // The right side of the screen is 0.5*screenWidth.
        // The bottom of the screen is -0.5*screenHeight.
        // The top of the screen is 0.5*screenHeight.

        // Position the spaceship near the bottom of the screen.
        spaceshipNode.position = CGPoint(x: 0.0, y: -0.4*screenHeight)

        // The size of the spaceship sprite image file is 394×347 pixels, which is
        // large compared to the size of the screen, so we scale it down to 25% this size.
        spaceshipNode.setScale(0.25)
    }

    override func didMove(to view: SKView) {
        // The background color must be set in didMove(to:) instead of init(coder:), because reasons.
        self.backgroundColor = UIColor.darkGray
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Called when the user begins touching the screen.

        let touchPosition = convertTouchLocationToScene(touch: touches.first!)
        aimSpaceship(at: touchPosition)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Called as the user moves their finger across the screen.

        let touchPosition = convertTouchLocationToScene(touch: touches.first!)
        aimSpaceship(at: touchPosition)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Called when the user stops touching the screen.
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Called when a touch is interrupted because a popup appeared, or the user
        // tapped the iPad's home button in the middle of a touch.
        // You can probably ignore this case.
    }

    func convertTouchLocationToScene(touch: UITouch) -> CGPoint {
        // The touch's position is in the coordinate space of the screen (0, 0 to 1024, 768),
        // but we need its position in the coordinate space of the SpriteKit scene,
        // which is (-512, -384 to 512, 384). This does the conversion.
        return touch.location(in: self)
    }

    func aimSpaceship(at position: CGPoint) {
        // Point the spaceship at a position on the screen.

        // Calculate the angle (in radians, not degrees) needed to point the spaceship's +Y axis toward the position.
        let angle = 0.5*CGFloat.pi + atan2(spaceshipNode.position.y - position.y, spaceshipNode.position.x - position.x)

        // Rotate the spaceship.
        let rotateAction = SKAction.rotate(toAngle: angle, duration: 0.0)
        spaceshipNode.run(rotateAction)
    }
}

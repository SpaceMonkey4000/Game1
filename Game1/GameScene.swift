
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
        self.backgroundColor = UIColor.darkGray
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered.
    }
}

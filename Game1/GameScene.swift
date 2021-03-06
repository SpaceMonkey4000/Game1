
import SpriteKit

class GameScene: SKScene {
    
    var gunNode = SKSpriteNode(imageNamed: "gun")
    var baseNode = SKSpriteNode(imageNamed: "base")

    var drones: [Drone] = []

    var lastTouchPosition = CGPoint(x: 0.0, y: 0.0)

    var shootingTimer: Timer?

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)

        BulletManager.sharedManager.scene = self

        // Called before the game starts.

        // Add the spaceship to the scene.
        self.addChild(gunNode)
        self.addChild(baseNode)

        // The center of the screen is 0, 0.
        // The left side of the screen is -0.5*screenWidth.
        // The right side of the screen is 0.5*screenWidth.
        // The bottom of the screen is -0.5*screenHeight.
        // The top of the screen is 0.5*screenHeight.

        // Position the spaceship near the bottom of the screen.
        gunNode.position = CGPoint(x: 0.0, y: -0.44*screenHeight)
        baseNode.position = CGPoint(x: 0.0, y: -0.46*screenHeight)
        
        // Put the gun behind the base. Bigger numbers are in the front.
        // Smaller numbers are in the back.
        gunNode.zPosition = 100.0
        baseNode.zPosition = 200.0

        // The size of the spaceship sprite image file is 394×347 pixels, which is
        // large compared to the size of the screen, so we scale it down to 25% this size.
        gunNode.setScale(1.0)
        gunNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)

        createDrone()
        createDrone()
        createDrone()
    }

    func createDrone() {
        let drone = Drone(firstWaitDuration: random(min: 0.0, max: 5.0), nextWaitDuration: 5.0, teleportDuration: 0.12)
        drones.append(drone)

        drone.spriteNode.zPosition = 50.0

        // This is what makes the drone slightly bigger.
        drone.spriteNode.setScale(1.3)

        self.addChild(drone.spriteNode)
    }

    override func didMove(to view: SKView) {
        // The background color must be set in didMove(to:) instead of init(coder:), because reasons.
        // self.backgroundColor = UIColor.darkGray
        self.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.23, alpha: 1.0)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Called when the user begins touching the screen.

        let touchPosition = convertTouchLocationToScene(touch: touches.first!)
        aimSpaceship(at: touchPosition)
        BulletManager.sharedManager.shootPlayerBullet(from: gunNode.position, to: touchPosition)
        
        lastTouchPosition = touchPosition
        startShooting()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Called as the user moves their finger across the screen.

        let touchPosition = convertTouchLocationToScene(touch: touches.first!)
        aimSpaceship(at: touchPosition)
        
        lastTouchPosition = touchPosition
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Called when the user stops touching the screen.
        
        stopShooting()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Called when a touch is interrupted because a popup appeared, or the user
        // tapped the iPad's home button in the middle of a touch.
        // You can probably ignore this case.
        
        stopShooting()
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
        var radians = 0.5*CGFloat.pi + atan2(gunNode.position.y - position.y, gunNode.position.x - position.x)
        
        var degrees = radians/CGFloat.pi*180.0
        

        if degrees > 90 && degrees < 180 {
            degrees = 90
        }
        if degrees < 270 && degrees >= 180 {
            degrees = -90
        }

        radians = degrees/180.0*CGFloat.pi
        
        // Rotate the spaceship.
        let rotateAction = SKAction.rotate(toAngle: radians, duration: 0.0)
        gunNode.run(rotateAction)
    }
    
    func startShooting() {
        assert(shootingTimer == nil, "Shooting timer is already defined.")

        shootingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (Timer) in
            BulletManager.sharedManager.shootPlayerBullet(from: self.gunNode.position, to: self.lastTouchPosition)
        })
    }
    
    func stopShooting() {
        shootingTimer?.invalidate()
        shootingTimer = nil
    }
        
}

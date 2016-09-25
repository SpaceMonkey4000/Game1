
import SpriteKit

class GameScene: SKScene {
    
    var gunNode = SKSpriteNode(imageNamed: "gun")
    var baseNode = SKSpriteNode(imageNamed: "base")
    var redDrone = SKSpriteNode(imageNamed: "red_drone")

    // The size of the iPad screen.
    let screenWidth = 1024.0
    let screenHeight = 768.0
    
    var lastTouchPosition = CGPoint(x: 0.0, y: 0.0)

    var shootingTimer: Timer?
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)

        // Called before the game starts.

        // Add the spaceship to the scene.
        self.addChild(gunNode)
        self.addChild(baseNode)
        self.addChild(redDrone)

        // The center of the screen is 0, 0.
        // The left side of the screen is -0.5*screenWidth.
        // The right side of the screen is 0.5*screenWidth.
        // The bottom of the screen is -0.5*screenHeight.
        // The top of the screen is 0.5*screenHeight.

        // Position the spaceship near the bottom of the screen.
        gunNode.position = CGPoint(x: 0.0, y: -0.44*screenHeight)
        baseNode.position = CGPoint(x: 0.0, y: -0.46*screenHeight)
        
        initializeDrone(drone: redDrone, waitDuration: 2.0, teleportDuration: 1.0)
        
        // Put the gun behind the base. Bigger numbers are in the front.
        // Smaller numbers are in the back.
        gunNode.zPosition = 100.0;
        baseNode.zPosition = 200.0;
        redDrone.zPosition = 50.0;
        
        // The size of the spaceship sprite image file is 394×347 pixels, which is
        // large compared to the size of the screen, so we scale it down to 25% this size.
        gunNode.setScale(1.0)
        gunNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        
        // This is what makes the drone slightly bigger.
        redDrone.setScale(1.3)
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
        shootBullet(at: touchPosition)
        
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
            self.shootBullet(at: self.lastTouchPosition)
        })
    }
    
    func stopShooting() {
        shootingTimer?.invalidate()
        shootingTimer = nil
    }
    
    func shootBullet(at position: CGPoint) {
        let bulletNode = SKSpriteNode(imageNamed: "playerball")
        bulletNode.setScale(1.5)
        self.addChild(bulletNode)
        bulletNode.position = gunNode.position

        bulletNode.zPosition = 75.0;

        // The direction we should fire the bullet.
        var direction = CGPoint(x: position.x - gunNode.position.x, y: position.y - gunNode.position.y)
        // Set the length of the direction vector to 1.
        let length = sqrt(direction.x*direction.x + direction.y*direction.y)
        direction.x /= length
        direction.y /= length
        
        // The distance that the bullet will travel before stopping. This is 50% more than
        // the width of the screen so it'll always be a point off the edge of the screen.
        let distance = CGFloat(screenWidth*1.5)
        
        // The end point of the bullet along its path before we remove it from the scene.
        let endPoint = CGPoint(x: gunNode.position.x + distance*direction.x, y: gunNode.position.y + distance*direction.y)
        
        // Move the bullet.
        let moveAction = SKAction.move(to: endPoint, duration: 1.45)
        bulletNode.run(moveAction) { 
            bulletNode.removeFromParent()
        }
    }
    
    func initializeDrone(drone: SKNode, waitDuration: TimeInterval, teleportDuration: TimeInterval) {
        // Set initial drone position.
        drone.position = randomDronePosition()

        // Make the drone move randomly around the screen.
        runDroneActions(drone: drone, waitDuration: waitDuration, teleportDuration: teleportDuration)
    }
    
    func runDroneActions(drone: SKNode, waitDuration: TimeInterval, teleportDuration: TimeInterval) {
        let waitAction = SKAction.wait(forDuration: waitDuration)
        let moveAction = SKAction.move(to: randomDronePosition(), duration: teleportDuration)
        
        // This makes the drone accelerate a little when it starts moving, and decelerate a little
        // before it stops moving. If you don't add this line, the drone will move at a constant rate.
        moveAction.timingMode = SKActionTimingMode.easeInEaseOut
        
        // Make a sequence of the wait and move actions.
        let actionSequence = SKAction.sequence([waitAction, moveAction])
        
        // Make the drone run the sequence of actions.
        drone.run(actionSequence) {
            // When the sequence of actions finishes, run a new sequence of drone actions.
            self.runDroneActions(drone: drone, waitDuration: waitDuration, teleportDuration: teleportDuration)
        }
    }
    
    func randomDronePosition() -> CGPoint {
        // random X of drone.
        let droneXspawn = random(min: -0.45, max: 0.45)
        // random Y of the drone.
        let droneYspawn = random(min: -0.2, max: 0.45)

        return CGPoint(x: droneXspawn*screenHeight, y: droneYspawn*screenHeight)
    }
    
    func random(min: Double, max: Double) -> Double {
        let s = Double(arc4random())/Double(UInt32.max)
        return min*(1.0 - s) + max*s;
    }
    
}

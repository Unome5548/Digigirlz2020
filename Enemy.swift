/// Copyright (c) 2020 Microsoft

import Foundation
import SpriteKit

class Enemy {

  //Default Image for the Enemy
  let defaultEnemyImage = "EnemyMove0"

  // Animation for the enemy Moving
  static let enemyMoveAnimation = SKAction.animate(with: [
    SKTexture(imageNamed: "EnemyMove0"),
    SKTexture(imageNamed: "EnemyMove1"),
    SKTexture(imageNamed: "EnemyMove2"),
    SKTexture(imageNamed: "EnemyMove3")
  ], timePerFrame: 0.1)

  //Animation for the enemy dying
  static let enemyDieAnimation = SKAction.animate(with: [
    SKTexture(imageNamed: "EnemyDie0"),
    SKTexture(imageNamed: "EnemyDie1"),
    SKTexture(imageNamed: "EnemyDie2"),
    SKTexture(imageNamed: "EnemyDie3"),
    SKTexture(imageNamed: "EnemyDie4"),
    SKTexture(imageNamed: "EnemyDie5"),
    SKTexture(imageNamed: "EnemyDie6"),
    SKTexture(imageNamed: "EnemyDie7"),
    SKTexture(imageNamed: "EnemyDie8")
  ], timePerFrame: 0.1)

  //SKSpriteNode for the Enemy
  var enemySprite: SKSpriteNode!

  //Max Move Speed of the Enemy
  let MAX_SPEED:CGFloat = 150

  //Values should be between 30 and 100.
  var enemySpeed:CGFloat = 70

  //Width of the enemy in pixels
  var enemyWidth:CGFloat = 100

  //Height of the enemy in pixels
  var enemyHeight:CGFloat = 75

  //Speed that the enemy should fire projectiles
  var enemyFireSpeed:Double = 3

  init(size: CGSize) {
    //Create a new SKSpriteNode with the Default Enemy Image
    enemySprite = SKSpriteNode(imageNamed: defaultEnemyImage)

//  Random Enemy Size
//    let randomSize = Utilities.random(min: 50, max: 200)

    //Static Enemy Size (same every time)
    let staticEnemySize = CGSize(width: enemyWidth, height: enemyHeight)
    enemySprite.size = staticEnemySize

    //Face the enemy sprite right
    enemySprite.xScale = 1

    //Pick a random Y coordinate to place our enemy between 30% of the screen, and the full height
    let randomY = Utilities.random(min: size.height * 0.3 , max: size.height - enemySprite.size.height/2)
    enemySprite.position = CGPoint(x: 0, y: randomY)

    //Run the enemy move animation forever
    enemySprite.run(SKAction.repeatForever(SKAction.sequence([Enemy.enemyMoveAnimation])))

    setupEnemyPhysics()
    setupEnemyMovement()
  }


  /// Setup the Movement pattern of our enemy
  func setupEnemyMovement() {

// moveEnemyToPoint()
 moveEnemyBackAndForthForever()
// moveAndWaitEnemyForever()
// moveEnemyRandomly()
//    moveEnemyCustom()
  }


  /// Setup the Shoot action for our enemy
  func setupEnemyShoot() {
    //Repeat the action forever
    enemySprite.run(SKAction.repeatForever(
      //Run the following sequence
      SKAction.sequence([
        //Wait the enemy fire time
        SKAction.wait(forDuration: enemyFireSpeed),
        //Run the enemy Shoot function
        SKAction.run({
          self.enemyShoot()
        })
      ])

    ))
  }

  //Helper function to create a runable shoot action
  func getEnemyShootAction() -> SKAction {
    return SKAction.run {
      self.enemyShoot()
    }
  }

  /// Move the enemy to the specified point
  func moveEnemyToPoint() {

     //Sets an action that will move our enemy to the point at x = 400
     let moveToPointAction = SKAction.move(to: CGPoint(x: 400, y: enemySprite.position.y), duration: 1)

     //Enemy should perform the sequence of actions to move back and forth, and repeat forever
     enemySprite.run(moveToPointAction)
   }

  /// Moves the enemy back and forth across the screen
  func moveEnemyBackAndForthForever() {
    setupEnemyShoot()

    //Sets up the duration (or time) that it takes to perform the action
    let duration = calculateActionDuration(maxDuration: 10)

    //Sets up an action that will move our enemy to the point at the far right of the screen
    let moveOutAction = SKAction.move(to: CGPoint(x: UIScreen.main.bounds.width, y: enemySprite.position.y), duration: TimeInterval(duration))

    //Sets an action that will move our enemy to the point at the far left of the screen
    let moveBackAction = SKAction.move(to: CGPoint(x: 0, y: enemySprite.position.y), duration: TimeInterval(duration))

    //Enemy should perform the sequence of actions to move back and forth, and repeat forever
    enemySprite.run(SKAction.repeatForever(SKAction.sequence([moveOutAction, moveBackAction])))
  }

  /// Moves the enemy to different points, and waits briefly between movements
  func moveAndWaitEnemyForever(){
    //Sets up the duration (or time) that it takes to perform the action.
    let duration:CGFloat = calculateActionDuration(maxDuration: 1)

    //Move enemy to the spot at x = 200
    let moveAction1 = SKAction.move(to: CGPoint(x: 200, y: enemySprite.position.y), duration: TimeInterval(duration))

    //Move enemy to the spot at x = 400
    let moveAction2 = SKAction.move(to: CGPoint(x: 400, y: enemySprite.position.y), duration: TimeInterval(duration))

    //Move enemy to the spot at x = 600
    let moveAction3 = SKAction.move(to: CGPoint(x: 600, y: enemySprite.position.y), duration: TimeInterval(duration))

    //Move enemy to the spot at x = 800
    let moveAction4 = SKAction.move(to: CGPoint(x: 800, y: enemySprite.position.y), duration: TimeInterval(duration))

    //Wait at the current spot for the time specified
    let waitAction = SKAction.wait(forDuration: TimeInterval(duration))

    let shootAction = getEnemyShootAction()

    //Enemy should perform the following sequence of actions, and repeat forever
    enemySprite.run(SKAction.repeatForever(SKAction.sequence([moveAction1,
                                                              waitAction,
                                                              shootAction,
                                                              moveAction2,
                                                              waitAction,
                                                              shootAction,
                                                              moveAction3,
                                                              waitAction,
                                                              shootAction,
                                                              moveAction4,
                                                              waitAction,
                                                              shootAction,
                                                              moveAction3,
                                                              waitAction,
                                                              shootAction,
                                                              moveAction2,
                                                              waitAction,
                                                              shootAction])))
  }

  /// Move the enemy randomly around the screen
  func moveEnemyRandomly() {
    //Determine the action duration based on a maxDuration time
    let duration = calculateActionDuration(maxDuration: 5)

    //Have the following sequence of actoins repeat forever
    enemySprite.run(SKAction.repeatForever(SKAction.sequence([
      SKAction.run {
        //Calculate a random X location
        let randomX = Utilities.random(min: 50, max: UIScreen.main.bounds.width - 50)
        //Calculate a random Y location
        let randomY = Utilities.random(min: 150 , max: UIScreen.main.bounds.height - 100)

        //Move the enemy to this new location in the time specified
        let randomMoveAction = SKAction.move(to: CGPoint(x: randomX, y: randomY), duration: TimeInterval(duration))

        //Run the move action
        self.enemySprite.run(randomMoveAction, withKey: "moveAction")
        //Wait the duration time so that we don't move to a new location till the prior one was achieved.
      },
      SKAction.wait(forDuration: TimeInterval(duration)),
      //Have the enemy shoot when he gets to his location
      ])
    ))
  }

  /// Moves the enemy to different points, and waits briefly between movements
  func moveEnemyCustom(){

    //Example Move Action.
    // Change 200 to a different number to move to that x coordinate.
    // Change 300 to a different number to move to that y coordinate.
    // Change the duration from 1 to something bigger to make the movement faster.
    // Copy and paste this to create more move actions. Make sure to give them different names
    let moveAction1 = SKAction.move(to: CGPoint(x: 50, y: 300), duration: TimeInterval(5))

    //Example Wait Action. Change the time from 1 to something else to make the wait longer or shorter
    let waitAction = SKAction.wait(forDuration: TimeInterval(1))

        enemySprite.run(SKAction.repeatForever(SKAction.sequence([
            moveAction1,
            waitAction,
            // Add more actions here.
    ])))
  }

  /// Figure out how long a single action should last based on a total duration time, and the speed settings
  /// - Parameter maxDuration: Total amount of time that would elapse at the slowest speed setting
  func calculateActionDuration(maxDuration: CGFloat) -> CGFloat{
    //Convert our speed setting to a value between 0 - 1
    let normalizedSpeed = enemySpeed/MAX_SPEED

    //Because faster speeds take less time, we need to invert our speed value so that a greater speed = less duration
    let durationVector = 1 - normalizedSpeed

    //Now that we have our durationVector we need to adjust it based on the max amount of time that we want the duration to last
    //A larger vector value will mean a longer duration, a shorter vector value will mean a shorter duration
    let actionDuration = durationVector * maxDuration

    //Return the value of the duration
    return actionDuration
  }

  /// Setup Physics for our enemy
  func setupEnemyPhysics() {
    enemySprite.physicsBody = SKPhysicsBody(rectangleOf: enemySprite.size)
    enemySprite.physicsBody?.isDynamic = true
    enemySprite.physicsBody?.categoryBitMask = PhysicsCategory.monster
    enemySprite.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
    enemySprite.physicsBody?.collisionBitMask = PhysicsCategory.none
  }

  /// Create a projectile and send it straight down
  func enemyShoot(){
    //Create a new Projectile Sprite
    let projectile = SKSpriteNode(imageNamed: "projectile")

    //Set the location of the new projectile to the enemies current location
    projectile.position = enemySprite.position

    //Create physics for the projectile
    projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
    projectile.physicsBody?.isDynamic = true
    projectile.physicsBody?.categoryBitMask = PhysicsCategory.enemyProjectile
    projectile.physicsBody?.contactTestBitMask = PhysicsCategory.player
    projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
    projectile.physicsBody?.usesPreciseCollisionDetection = true

    //Add the projectile to the world
    self.enemySprite.parent?.addChild(projectile)

    //Send the projectile to the bottom of the screen
    let realDest = CGPoint(x: projectile.position.x, y: -100)

    //Move the projectile to the location
    let actionMove = SKAction.move(to: realDest, duration: 2.0)

    //Remove the projectile once it goes offscreen
    let actionMoveDone = SKAction.removeFromParent()

    //Run the move and remove actions for our projectile
    projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
  }
  
}

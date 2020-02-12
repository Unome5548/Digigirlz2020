/// Copyright (c) 2020 Microsoft

import Foundation
import SpriteKit

class Player{

  // Starting image of the player
  let defaultPlayerImage = "PlayerMove5"

  //SKSprite Node for the Player
  let playerSprite: SKSpriteNode!

  //Speed of the Player
  let playerSpeed:CGFloat = 80

  //Set the Player Width
  let playerWidth:CGFloat = 150

  //Set the Player Height
  let playerHeight:CGFloat = 150

  //Animation for the player's attack
  let playerShootAnimation = SKAction.animate(with: [
    SKTexture(imageNamed: "PlayerAttack0"),
    SKTexture(imageNamed: "PlayerAttack1"),
    SKTexture(imageNamed: "PlayerAttack2"),
    SKTexture(imageNamed: "PlayerAttack3"),
    SKTexture(imageNamed: "PlayerAttack4"),
    SKTexture(imageNamed: "PlayerAttack5"),
    SKTexture(imageNamed: "PlayerAttack6"),
    SKTexture(imageNamed: "PlayerAttack7"),
    SKTexture(imageNamed: "PlayerAttack8"),
    SKTexture(imageNamed: "PlayerAttack9")
  ], timePerFrame: 0.04)

  //Animation for the player moving
  let playerMoveAnimation = SKAction.animate(with: [
    SKTexture(imageNamed: "PlayerMove5"),
    SKTexture(imageNamed: "PlayerMove6"),
    SKTexture(imageNamed: "PlayerMove7"),
    SKTexture(imageNamed: "PlayerMove8"),
    SKTexture(imageNamed: "PlayerMove9"),
    SKTexture(imageNamed: "PlayerMove0"),
    SKTexture(imageNamed: "PlayerMove1"),
    SKTexture(imageNamed: "PlayerMove2"),
    SKTexture(imageNamed: "PlayerMove3"),
    SKTexture(imageNamed: "PlayerMove4"),
    SKTexture(imageNamed: "PlayerMove5"),
    SKTexture(imageNamed: "PlayerMove6"),
    SKTexture(imageNamed: "PlayerMove7"),
    SKTexture(imageNamed: "PlayerMove8"),
    SKTexture(imageNamed: "PlayerMove9"),
    SKTexture(imageNamed: "PlayerMove0"),
    SKTexture(imageNamed: "PlayerMove1"),
    SKTexture(imageNamed: "PlayerMove2"),
    SKTexture(imageNamed: "PlayerMove3"),
    SKTexture(imageNamed: "PlayerMove4")
  ], timePerFrame: 0.028)


  init(size: CGSize, startX: Int, startY: Int){
    //Setup a new player with the defaultPlayerImage
    playerSprite = SKSpriteNode(imageNamed: defaultPlayerImage)

    //Set the player's starting location to half the width of the screen at 10% height
    playerSprite.position = CGPoint(x: startX, y: startY)

    //Set the size of the player
    playerSprite.size = CGSize(width: playerWidth, height: playerHeight)

    //Set up the phyics environment for the player
    setupPlayerPhysics()
  }


  /// Moves the player right
  func movePlayerRight() {
    //Set the direction of the player to face right
    playerSprite.xScale = 1

    //Run an action that moves the player to a position right based on the player speed
    playerSprite.run(SKAction.move(to: CGPoint(x: playerSprite.position.x + playerSpeed, y: playerSprite.position.y), duration: 0.5))

    //Run an action that plays the animation of the player moving
    playerSprite.run(SKAction.sequence([playerMoveAnimation]), withKey: "playerMove")
  }

  func movePlayerLeft() {
    //Set the direction of the player to face left
    playerSprite.xScale = -1

    //Run an action that moves the player to a position left based on the player speed
    playerSprite.run(SKAction.move(to: CGPoint(x: playerSprite.position.x - playerSpeed, y: playerSprite.position.y), duration: 0.5))

    //Run an action that plays the animation of the player moving
    playerSprite.run(SKAction.sequence([playerMoveAnimation]), withKey: "playerMove")
  }

  func playerShoot(touchLocation:CGPoint) {
    //Create a Projectile
    let projectile = SKSpriteNode(imageNamed: "projectile")

    //Have the projectile's starting position be where the player is right now
    projectile.position = playerSprite.position

    //Setup the Physics of the projectile
    projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
    projectile.physicsBody?.isDynamic = true
    projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
    projectile.physicsBody?.contactTestBitMask = PhysicsCategory.monster
    projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
    projectile.physicsBody?.usesPreciseCollisionDetection = true


    //Figure out which directoin the player should face when he shoots
    let offset = touchLocation - projectile.position

    if offset.x < 0 {
      //Face the player left
      playerSprite.xScale = -1
    }else {
      //Face the player right
      playerSprite.xScale = 1
    }

    //Run the Player Attack animation
    playerSprite.run(SKAction.sequence([playerShootAnimation]))

    //Add the projectile to the world
    self.playerSprite.parent?.addChild(projectile)

    //Calculate a normalized vector
    let direction = offset.normalized()

    //Create a target point way off screen
    let shootAmount = direction * 1000

    //Calculate a real point based on the target vector
    let realDest = shootAmount + projectile.position

    //Move the projectile to that point
    let actionMove = SKAction.move(to: realDest, duration: 2.0)

    //Create an action to remove the projectile when it reaches its location
    let actionMoveDone = SKAction.removeFromParent()

    //Run the actions to move and remove the projectile
    projectile.run(SKAction.sequence([actionMove, actionMoveDone]))

//    self.playerSprite.parent?.run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
  }

  //Setup the Physics world for the player
  func setupPlayerPhysics() {
    playerSprite.physicsBody = SKPhysicsBody(rectangleOf: playerSprite.size)
    playerSprite.physicsBody?.isDynamic = true
    playerSprite.physicsBody?.categoryBitMask = PhysicsCategory.player
    playerSprite.physicsBody?.contactTestBitMask = PhysicsCategory.enemyProjectile
    playerSprite.physicsBody?.collisionBitMask = PhysicsCategory.none
  }

}

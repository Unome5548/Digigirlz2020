/// Copyright (c) 2020 Microsoft Corporation

import SpriteKit

class GameScene: SKScene {

  //Setup the Sprite for the background with the background image
  let bg = SKSpriteNode(imageNamed: "background")

  var player: Player!

  //Setup UI
  let leftButton = SKSpriteNode(imageNamed: "moveButton")
  let rightButton = SKSpriteNode(imageNamed: "moveButton")
  let scoreLabel = SKLabelNode(text: "SCORE: 0")
  let playerHealthLabel = SKLabelNode(text: "HEALTH: 0")

  //Set the score to 0 to start the game
  var currentScore = 0;

  //Set the health of the player
  var playerHealth = 100

  var playerStartX = 400

  var playerStartY = 100

  //Set the number of enemies that are currently in the game
  var enemyCount = 0

  //Set the maximum number of enemies that should exist at once
  let MAX_ENEMIES = 50

  //Setup a score needed to win
  let WIN_SCORE = 1000

  /// This happens when the scene is created
  /// - Parameter view: parent view
  override func didMove(to view: SKView) {

    //setup any UI for the game
    setupUI()

    //Create our player
    player = Player(size: size, startX: playerStartX, startY: playerStartY)

    //Add the player to the world
    addChild(player.playerSprite)

    //Setup Basic Physics of our world
    physicsWorld.gravity = .zero
    physicsWorld.contactDelegate = self

    //Repeat an action forever that creates an enemy every 2 seconds
    run(SKAction.repeatForever(SKAction.sequence([SKAction.run({
      //only create an enemy if we haven't exceeded our enemy count
      if self.enemyCount < self.MAX_ENEMIES {
        self.createEnemy()
      }
      //Wait 2 seconds
    }), SKAction.wait(forDuration: 2)
    ])))

    //Setup Background Music
    let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")

    //Music should loop over and over
    backgroundMusic.autoplayLooped = true

    //Add the background music to our world
//    addChild(backgroundMusic)
  }

  //Create an enemy and add to the world
  func createEnemy() {
    //Create the enemy object
    let newEnemy = Enemy(size: size)

    //Increment our enemy count
    enemyCount+=1

    //Add the enemy to the world
    addChild(newEnemy.enemySprite)
  }

  /// Setup UI for the Game
  func setupUI() {
    //Place the background at the 0,0 spot
    bg.anchorPoint = CGPoint.zero
    //Make the background fullscreen
    bg.size = self.view!.bounds.size
    //Set the background to the bottom of the objects depth chart (always in the back)
    bg.zPosition = -1
    //Add the background to the world
    addChild(bg)

    //Add the left button 10% on the width oof the screen
    leftButton.position = CGPoint(x: size.width * 0.1, y: size.height * 0.15)
    //Make the left Button in the front
    leftButton.zPosition = 1
    //Set the Button's size
    leftButton.size = CGSize(width: 75, height: 75)

    //Add the left button 90% on the width oof the screen
    rightButton.position = CGPoint(x: size.width * 0.9, y: size.height * 0.15)
    //Make the right Button in the front
    rightButton.zPosition = 1
    //Flip the button's direction (so it points right)
    rightButton.xScale = -1
    //Set the Button's size
    rightButton.size = CGSize(width: 75, height: 75)

    //Add Both Buttons to our world
    addChild(leftButton)
    addChild(rightButton)

    //Setup a Score in the top right of the screen
    scoreLabel.position = CGPoint(x: size.width * 0.85, y: size.height * 0.9)
    scoreLabel.fontName = "HelveticaNeue-Bold"
    //Add the score to the world
    addChild(scoreLabel)

    //Setup a Health indicator in the to pright of the screen
    playerHealthLabel.position = CGPoint(x: size.width * 0.85, y: size.height * 0.8)
    playerHealthLabel.fontName = "HelveticaNeue-Bold"
    playerHealthLabel.text = "HEALTH: \(playerHealth)"
    //Add the health label to the world
    addChild(playerHealthLabel)
  }

  //Get touch events
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    //Iterate over the different touches
    for touch in touches {
      //move the player left when the left button is touched
      if leftButton.contains(touch.location(in: self)) {
        player.movePlayerLeft()
        //Move the player right if the right button is touched
      }else if rightButton.contains(touch.location(in: self)) {
        player.movePlayerRight()
      }else {
        //If neither button is touched, fire a projectile instead
        let touchLocation = touch.location(in: self)
        player.playerShoot(touchLocation: touchLocation)
      }
    }
  }

  //Setup Collision logic for the monster and a projectile
  func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
    //Remove the projectile from the world
    projectile.removeFromParent()

    //Increase the score for hitting a monster
    currentScore += 100
    //Change the text on our score label
    scoreLabel.text = "SCORE: \(currentScore)"

    //Setup an action to remove the monster
    let removeMonsterAction = SKAction.run {
      monster.removeFromParent()
    }

    //Remove the prior animation of the enemy
    monster.removeAllActions()
    //Change the physics body so the projectiles won't hit the enemy anymore
    monster.physicsBody?.categoryBitMask = PhysicsCategory.none
    //Run the die animation and remove the enemy
    monster.run(SKAction.sequence([Enemy.enemyDieAnimation, removeMonsterAction]))

    //Decrement our enemyCount
    enemyCount -= 1

    //Show the win screen if we exceed the necesssary score
    if currentScore >= WIN_SCORE {
      //Show the Game Over Screen
      let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
      let gameOverScene = GameOverScene(size: size, won: true, score: currentScore)
      self.view?.presentScene(gameOverScene, transition: reveal)
    }
  }

  func projectileDidCollideWithPlayer(enemyProjectile: SKSpriteNode, player: SKSpriteNode) {
    //Remove the enemy projectile from the world
    enemyProjectile.removeFromParent()
    enemyCount -= 1

    //Decrease the score
    currentScore -= 10
    //Decrease the health
    playerHealth -= 10

    //Update the Score and Health Labels
    scoreLabel.text = "SCORE: \(currentScore)"
    playerHealthLabel.text = "HEALTH: \(playerHealth)"

    //If the player has no more health, show the game over screen
    if playerHealth <= 0 {
      //Show the Game Over SCreen
      let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
      let gameOverScene = GameOverScene(size: size, won: false, score: currentScore)
      self.view?.presentScene(gameOverScene, transition: reveal)
    }
  }
  
}

//Physics Logic for the Game
extension GameScene: SKPhysicsContactDelegate {
  func didBegin(_ contact: SKPhysicsContact) {

    var firstBody: SKPhysicsBody
    var secondBody: SKPhysicsBody
    //Sort the bitmasks
    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
      firstBody = contact.bodyA
      secondBody = contact.bodyB
    } else {
      firstBody = contact.bodyB
      secondBody = contact.bodyA
    }

    //Detect if the two objects that collided are a monster and a projectile
    if ((firstBody.categoryBitMask & PhysicsCategory.monster != 0) &&
        (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
      if let monster = firstBody.node as? SKSpriteNode,
        let projectile = secondBody.node as? SKSpriteNode {
        projectileDidCollideWithMonster(projectile: projectile, monster: monster)
      }

    //Detect if the two objects that collided are the player and the monster's projectile
    }else if ((firstBody.categoryBitMask & PhysicsCategory.player != 0) &&
        (secondBody.categoryBitMask & PhysicsCategory.enemyProjectile != 0)) {
      if let player = firstBody.node as? SKSpriteNode,
        let enemyProjectile = secondBody.node as? SKSpriteNode {
        projectileDidCollideWithPlayer(enemyProjectile: enemyProjectile, player: player)
      }
    }
  }
}

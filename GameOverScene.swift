/// Copyright (c) 2020 Microsoft

import Foundation
import SpriteKit

class GameOverScene: SKScene {

  var playAgainButton: SKLabelNode!

  init(size: CGSize, won: Bool, score: Int) {
    super.init(size: size)

    backgroundColor = UIColor.black

    let message = won ? "You Won!" : "You Lose :["

    let label = SKLabelNode(text: message)

    label.fontName = "Chalkduster"
    label.fontColor = UIColor.white
    label.fontSize = 32
    label.position = CGPoint(x: size.width/2, y: size.height * 0.6)

    let scoreLabel = SKLabelNode(text: "Score: \(score)")
    scoreLabel.fontColor = UIColor.white
    scoreLabel.fontName = "Chalkduster"
    scoreLabel.fontSize = 24
    scoreLabel.position = CGPoint(x: size.width/2, y: size.height * 0.4)

    playAgainButton = SKLabelNode(text: "Play Again")
    playAgainButton.fontColor = UIColor.white
    playAgainButton.fontName = "Chalkduster"
    playAgainButton.fontSize = 20
    playAgainButton.position = CGPoint(x: size.width/2, y: size.height * 0.2)

    addChild(label)
    addChild(scoreLabel)
    addChild(playAgainButton)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let firstTouch = touches.first {
      if playAgainButton.contains(firstTouch.location(in: self)) {
        let gameScene = GameScene(size: size)
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        self.view?.presentScene(gameScene, transition: reveal)
      }
    }
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

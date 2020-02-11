/// Copyright (c) 2020 Microsoft

import Foundation
import SpriteKit

func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
  func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
  }
#endif

extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }

  func normalized() -> CGPoint {
    return self / length()
  }
}

struct PhysicsCategory {
  static let none           : UInt32 = 0
  static let all            : UInt32 = UInt32.max
  static let monster        : UInt32 = 1 << 1       // 1
  static let projectile     : UInt32 = 1 << 2      // 2
  static let player         : UInt32 = 1 << 3
  static let enemyProjectile: UInt32 = 1 << 4
}

class Utilities {

  class func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
  }

  class func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
  }

}

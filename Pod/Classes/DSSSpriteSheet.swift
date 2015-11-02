import Foundation
import UIKit

class DSSSpriteSheet {

  var itemWidth, itemHeight, itemsPerRow : Int;
  var images : NSMutableArray = []

  init(withItemWidth width: Int, height: Int, itemsPerRow: Int) {
    self.itemWidth = width
    self.itemHeight = height
    self.itemsPerRow = itemsPerRow
  }

  func add(image: UIImage) {
    self.images.addObject(image)
  }

  func toSpriteSheet() -> UIImage {
    // Create a new UIImage (to use as our canvas)
    let canvasSize : CGSize = CGSizeMake(
      CGFloat(self._canvasWidth()),
      CGFloat(self._canvasHeight())
    )
    UIGraphicsBeginImageContext(canvasSize)

    // Set a background fill
    let backgroundColor = UIColor.whiteColor()
    let cgRect : CGRect = CGRectMake(0, 0, CGFloat(self._rightX()), CGFloat(self._bottomY()))
    backgroundColor.set()
    UIRectFill(cgRect)

    // Add each image to the canvas
    for (var i=0; i<self.images.count; i++) {
      let xPosition : Int = self._xPositionForIndex(i)
      let yPosition : Int = self._yPositionForIndex(i)
      let image : UIImage = self.images[i] as! UIImage
      let cgRect : CGRect = CGRectMake(
        CGFloat(xPosition),
        CGFloat(yPosition),
        CGFloat(self.itemWidth),
        CGFloat(self.itemHeight)
      )
      image.drawInRect(cgRect)
    }

    // Return the new UIImage
    let spriteSheet : UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return spriteSheet
  }

  /*** "private" methods ***/

  func _xPositionForIndex(index: Int) -> Int {
    let indexWithinRow : Int = index % self.itemsPerRow
    let xPosition : Int = indexWithinRow * self.itemWidth
    return xPosition
  }

  func _yPositionForIndex(index: Int) -> Int {
    let indexOfRow: Int = Int(floor(Double(index / self.itemsPerRow)))
    let yPosition: Int = indexOfRow * self.itemHeight
    return yPosition
  }

  func _canvasWidth() -> Int {
    return self._columns() * self.itemWidth
  }

  func _canvasHeight() -> Int {
    return self._rows() * self.itemHeight
  }

  func _rows() -> Int {
    return Int(ceil(Double(self.images.count / self.itemsPerRow)))
  }

  func _columns() -> Int {
    return min(self.images.count, self.itemsPerRow)
  }

  func _rightX() -> Int {
    return self._columns() * self.itemWidth
  }

  func _bottomY() -> Int {
    return self._rows() * self.itemHeight
  }

}

enum  DSSSpriteSheetError: ErrorType {
  case IndexOutOfBounds
}

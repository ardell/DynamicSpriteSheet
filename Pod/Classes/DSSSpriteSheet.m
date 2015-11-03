//
//  DSSSpriteSheet.m
//  DynamicSpriteSheet
//
//  Created by Jason Ardell on 11/2/15.
//  Copyright (c) 2015 Jason Ardell. All rights reserved.
//

#import "DSSSpriteSheet.h"

@implementation DSSSpriteSheet {
  int _itemWidth, _itemHeight, _itemsPerRow, _borderWidth;
  NSMutableArray *_images;
}

- (instancetype)initWithItemWidth:(int)width
                           height:(int)height
                      itemsPerRow:(int)itemsPerRow
                      borderWidth:(int)borderWidth
{
  if (self = [super init]) {
    _images = [[NSMutableArray alloc] init];
    _itemWidth = width;
    _itemHeight = height;
    _itemsPerRow = itemsPerRow;
    _borderWidth = borderWidth;
  }
  return self;
}

- (void)add:(UIImage *)image
{
  [_images addObject:image];
}

- (UIImage *)toSpriteSheet
{
  // Create a new UIImage (to use as our canvas)
  CGSize canvasSize = CGSizeMake(
    (CGFloat)[self _canvasWidth],
    (CGFloat)[self _canvasHeight]
  );
  UIGraphicsBeginImageContext(canvasSize);

  // Set a background fill
  UIColor *backgroundColor = [UIColor whiteColor];
  CGRect cgRect = CGRectMake(0, 0, (CGFloat)[self _canvasWidth], (CGFloat)[self _canvasHeight]);
  [backgroundColor set];
  UIRectFill(cgRect);

  // Add each image to the canvas
  for (int i=0; i<_images.count; i++) {
    int xPosition = [self _xPositionForIndex:i];
    int yPosition = [self _yPositionForIndex:i];
    UIImage *image = [_images objectAtIndex:i];
    CGRect cgRect = CGRectMake(
      (CGFloat)xPosition,
      (CGFloat)yPosition,
      (CGFloat)_itemWidth,
      (CGFloat)_itemHeight
    );
    [image drawInRect:cgRect];
  }

  // Return the new UIImage
  UIImage *spriteSheet = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return spriteSheet;
}

/*** "private" methods ***/

- (int)_xPositionForIndex:(int)index
{
  int indexWithinRow = index % _itemsPerRow;
  int xPosition = _borderWidth + indexWithinRow * (_itemWidth + _borderWidth);
  return xPosition;
}

- (int)_yPositionForIndex:(int)index
{
  int indexOfRow = (int)(double)floor((double)index / (double)_itemsPerRow);
  int yPosition = _borderWidth + indexOfRow * (_itemHeight + _borderWidth);
  return yPosition;
}

- (int)_canvasWidth
{
  // border  img  border  img  border
  return _borderWidth + [self _columns] * (_itemWidth + _borderWidth);
}

- (int)_canvasHeight
{
  // border  img  border  img  border
  return _borderWidth + [self _rows] * (_itemHeight + _borderWidth);
}

- (int)_rows
{
  return (int)(double)ceil((double)[_images count] / (double)_itemsPerRow);
}

- (int)_columns
{
  return (int)MIN(_images.count, _itemsPerRow);
}

@end

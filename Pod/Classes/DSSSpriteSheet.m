//
//  DSSSpriteSheet.m
//  DynamicSpriteSheet
//
//  Created by Jason Ardell on 11/2/15.
//  Copyright (c) 2015 Jason Ardell. All rights reserved.
//

#import "DSSSpriteSheet.h"
#import "UIImage+Crop.h"

@implementation DSSSpriteSheet {
  int _itemWidth, _itemHeight, _itemsPerRow, _borderWidth;
  NSMutableArray *_images;
  UIImage *_image;
}

- (instancetype)initWithItemWidth:(int)width
                           height:(int)height
                      itemsPerRow:(int)itemsPerRow
                      borderWidth:(int)borderWidth
{
  return [self initWithItemWidth:width
                          height:height
                     itemsPerRow:itemsPerRow
                     borderWidth:borderWidth
                           image:nil];
}

- (instancetype)initWithItemWidth:(int)width
                           height:(int)height
                      itemsPerRow:(int)itemsPerRow
                      borderWidth:(int)borderWidth
                            image:(UIImage *)image
{
  if (self = [super init]) {
    _itemWidth = width;
    _itemHeight = height;
    _itemsPerRow = itemsPerRow;
    _borderWidth = borderWidth;

    if (image) {
      _image = image;
    } else {
      _images = [[NSMutableArray alloc] init];
    }
  }
  return self;
}

- (void)addImage:(UIImage *)image withBorderColor:(UIColor *)borderColor
{
  NSDictionary *dict = @{
    @"imageData":   UIImagePNGRepresentation(image),
    @"borderColor": borderColor,
  };
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
  [_images addObject:data];
}

- (void)addImage:(UIImage *)image
{
  [self addImage:image withBorderColor:[UIColor whiteColor]];
}

- (int)itemWidth
{
  return _itemWidth;
}

- (int)itemHeight
{
  return _itemHeight;
}

- (int)xPositionForIndex:(int)index
{
  // border  image  border  border  image  border  border  image  border
  int indexWithinRow = index % _itemsPerRow;
  int xPosition = _borderWidth + indexWithinRow * (_itemWidth + 2*_borderWidth);
  return xPosition;
}

- (int)yPositionForIndex:(int)index
{
  // border  image  border  border  image  border  border  image  border
  int indexOfRow = (int)(double)floor((double)index / (double)_itemsPerRow);
  int yPosition = _borderWidth + indexOfRow * (_itemHeight + 2*_borderWidth);
  return yPosition;
}

- (UIImage *)imageAtIndex:(int)index
{
  // Calculate x/y coords
  int x = [self xPositionForIndex:index];
  int y = [self yPositionForIndex:index];

  // Prepare sprite sheet if it doesn't already exist
  if (!_image) [self toSpriteSheet];

  // Make sure we're not requesting an image that's outside the bounds
  // of the sprite
  CGSize sheetSize = [_image size];
  if (x+_itemWidth > sheetSize.width || y+_itemHeight > sheetSize.height) {
    return nil;
  }

  // Crop out the image starting at (x, y)
  CGRect rect = CGRectMake(x, y, _itemWidth, _itemHeight);
  return [_image crop:rect];
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

  // Add each border and image to the canvas
  for (int i=0; i<_images.count; i++) {
    int xPosition = [self xPositionForIndex:i];
    int yPosition = [self yPositionForIndex:i];

    // Border
    CGRect borderRect = CGRectMake(
      (CGFloat)(xPosition - _borderWidth),
      (CGFloat)(yPosition - _borderWidth),
      (CGFloat)(_itemWidth + 2*_borderWidth),
      (CGFloat)(_itemHeight + 2*_borderWidth)
    );
    [[self _borderColorAtIndex:i] set];
    UIRectFill(borderRect);

    // Image
    NSDictionary *dict = [self _dictionaryAtIndex:i];
    UIImage *image = [UIImage imageWithData:[dict objectForKey:@"imageData"]];
    CGRect cgRect = CGRectMake(
      (CGFloat)xPosition,
      (CGFloat)yPosition,
      (CGFloat)_itemWidth,
      (CGFloat)_itemHeight
    );
    [image drawInRect:cgRect];
  }

  // Build the sprite sheet
  UIImage *spriteSheet = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  _image = spriteSheet;

  // Return the new UIImage
  return spriteSheet;
}

/*** "private" methods ***/

- (NSDictionary *)_dictionaryAtIndex:(int)index
{
  NSData *data = [_images objectAtIndex:index];
  return (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (UIColor *)_borderColorAtIndex:(int)index
{
  NSDictionary *dict = [self _dictionaryAtIndex:index];
  return [dict objectForKey:@"borderColor"];
}

- (int)_xPositionForColumn:(int)column
{
  return _borderWidth + column * (_itemWidth + 2*_borderWidth);
}

- (int)_yPositionForRow:(int)row
{
  return _borderWidth + row * (_itemHeight + 2*_borderWidth);
}

- (int)_canvasWidth
{
  return [self _columns] * (_itemWidth + 2*_borderWidth);
}

- (int)_canvasHeight
{
  return [self _rows] * (_itemHeight + 2*_borderWidth);
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

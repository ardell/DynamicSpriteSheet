//
//  DSSSpriteSheet.h
//  DynamicSpriteSheet
//
//  Created by Jason Ardell on 11/2/15.
//  Copyright (c) 2015 Jason Ardell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DSSSpriteSheet : NSObject

- (instancetype)initWithItemWidth:(int)width
                           height:(int)height
                      itemsPerRow:(int)itemsPerRow
                      borderWidth:(int)borderWidth;

- (instancetype)initWithItemWidth:(int)width
                           height:(int)height
                      itemsPerRow:(int)itemsPerRow
                      borderWidth:(int)borderWidth
                            image:(UIImage *)image;

- (void)addImage:(UIImage *)image withBorderColor:(UIColor *)borderColor;
- (void)addImage:(UIImage *)image;

- (UIImage *)imageAtIndex:(int)index;
- (int)itemWidth;
- (int)itemHeight;
- (int)xPositionForIndex:(int)index;
- (int)yPositionForIndex:(int)index;

- (UIImage *)toSpriteSheet;

@end

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

- (instancetype)loadFromSheet:(UIImage *)sheet
                        width:(int)width
                       height:(int)height
                  itemsPerRow:(int)itemsPerRow
                  borderWidth:(int)borderWidth;

- (void)add:(UIImage *)image;

- (UIImage *)toSpriteSheet;

@end

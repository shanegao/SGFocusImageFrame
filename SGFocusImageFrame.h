//
//  SGFocusImageFrame.h
//  SGFocusImageFrame
//
//  Created by Shane Gao on 17/6/12.
//  Copyright (c) 2012 Shane Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SGFocusImageItem;
@class SGFocusImageFrame;

#pragma mark - SGFocusImageFrameDelegate
@protocol SGFocusImageFrameDelegate <NSObject>

- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item;

@end


@interface SGFocusImageFrame : UIView <UIGestureRecognizerDelegate, UIScrollViewDelegate>

- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate focusImageItems:(SGFocusImageItem *)items, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate focusImageItemsArrray:(NSArray *)items;

@property (nonatomic, assign) BOOL autoScrolling;
@property (nonatomic, assign) id<SGFocusImageFrameDelegate> delegate;
@end

@interface UIView (Layout)
- (CGFloat)x;
- (void)setX:(CGFloat)xx;
- (CGFloat)y;
- (void)setY:(CGFloat)yy;
- (CGFloat)width;
- (void)setWidth:(CGFloat)w;
- (CGFloat)height;
- (void)setHeight:(CGFloat)h;
@end

//
//  SGFocusImageFrame.h
//  SGFocusImageFrame
//
//  Created by Shane Gao on 17/6/12.
//  Copyright (c) 2012 Shane Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGFocusImageItem : NSObject
@property (nonatomic, strong)  NSString     *title;
@property (nonatomic, strong)  UIImage      *image;
@property (nonatomic)          NSInteger     tag;
- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag;
+ (id)itemWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag;
@end


#pragma mark - SGFocusImageFrameDelegate

@class SGFocusImageFrame;
@protocol SGFocusImageFrameDelegate <NSObject>
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame
           didSelectItem:(SGFocusImageItem *)item;
@end

@interface SGFocusImageFrame : UIView <UIGestureRecognizerDelegate,
                                       UIScrollViewDelegate>
- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate focusImageItems:(SGFocusImageItem *)items, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate focusImageItemsArrray:(NSArray *)items;

@property (nonatomic, assign) BOOL autoScrolling;
@property (nonatomic) NSTimeInterval switchTimeInterval; // default for 10.0s
@property (nonatomic, assign) id<SGFocusImageFrameDelegate> delegate;
@property (nonatomic, copy) void (^didSelectItemBlock)(SGFocusImageItem *item);
@end

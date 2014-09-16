//
//  SGFocusImageFrame.m
//  SGFocusImageFrame
//
//  Created by Shane Gao on 17/6/12.
//  Copyright (c) 2012 Shane Gao. All rights reserved.
//

#import "SGFocusImageFrame.h"
#import <objc/runtime.h>

static const void *SG_FOCUS_ITEM_ASS_KEY = &SG_FOCUS_ITEM_ASS_KEY;

#define HEIGHT_OF_PAGE_CONTROL 20.f

#pragma mark - SGFocusImageItem Definition
@implementation SGFocusImageItem
- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.tag = tag;
    }
    return self;
}

+ (id)itemWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag
{
    return [[SGFocusImageItem alloc] initWithTitle:title image:image tag:tag];
}

@end

#pragma mark - SGFocusImageFrame Definition

@interface SGFocusImageFrame ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation SGFocusImageFrame

- (void)dealloc
{
    objc_setAssociatedObject(self, SG_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate focusImageItemsArrray:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        objc_setAssociatedObject(self, SG_FOCUS_ITEM_ASS_KEY, items, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.delegate = delegate;
        [self initImageFrame];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
           delegate:(id<SGFocusImageFrameDelegate>)delegate
    focusImageItems:(SGFocusImageItem *)firstItem, ...
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *imageItems = [NSMutableArray array];  
        SGFocusImageItem *eachItem;
        va_list argumentList;
        if (firstItem) {
            [imageItems addObject: firstItem];
            va_start(argumentList, firstItem);       
            while((eachItem = va_arg(argumentList, SGFocusImageItem *))) {
                [imageItems addObject: eachItem];            
            }
            va_end(argumentList);
        }
        objc_setAssociatedObject(self, SG_FOCUS_ITEM_ASS_KEY, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.delegate = delegate;
        [self initImageFrame];
    }
    return self;
}

- (void)initImageFrame
{
    [self initParameters];
    [self setupViews];
}

#pragma mark - private methods

- (void)initParameters
{
    self.switchTimeInterval = 10.f;
    self.autoScrolling = YES;
}

- (void)setupViews
{
    CGFloat mainWidth = self.frame.size.width, mainHeight = self.frame.size.height;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, mainWidth, mainHeight - HEIGHT_OF_PAGE_CONTROL)];
    
    CGSize size = CGSizeMake(mainWidth, HEIGHT_OF_PAGE_CONTROL);
    CGRect pcFrame = CGRectMake(mainWidth *.5 - size.width *.5, mainHeight - size.height, size.width, size.height);
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:pcFrame];
    [pageControl addTarget:self action:@selector(pageControlTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:scrollView];
    [self addSubview:pageControl];
    
    /*
    scrollView.layer.cornerRadius = 10;
    scrollView.layer.borderWidth = 1 ;
    scrollView.layer.borderColor = [[UIColor lightGrayColor ] CGColor];
     */
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.directionalLockEnabled = YES;
    scrollView.alwaysBounceHorizontal = YES;
    
    pageControl.currentPage = 0;
    
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    [scrollView addGestureRecognizer:tapGestureRecognize];
    
    NSArray *imageItems = objc_getAssociatedObject(self, SG_FOCUS_ITEM_ASS_KEY);
    pageControl.numberOfPages = imageItems.count;
    
    CGSize scrollViewSize = scrollView.frame.size;
    
    for (int i = 0; i < imageItems.count; i++) {
        SGFocusImageItem *item = [imageItems objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * scrollViewSize.width, 0.f, scrollViewSize.width, scrollViewSize.height)];
        imageView.image = item.image;
        imageView.contentMode = UIViewContentModeScaleToFill;
        [scrollView addSubview:imageView];
    }
    
    scrollView.contentSize = CGSizeMake(scrollViewSize.width * imageItems.count, mainHeight - HEIGHT_OF_PAGE_CONTROL);
    self.scrollView = scrollView;
    self.pageControl = pageControl;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - Actions

- (void)pageControlTapped:(id)sender
{
    UIPageControl *pc = (UIPageControl *)sender;
    [self moveToTargetPage:pc.currentPage];
}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    int targetPage = (int)(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
    NSArray *imageItems = objc_getAssociatedObject(self, SG_FOCUS_ITEM_ASS_KEY);
    if (targetPage > -1 && targetPage < imageItems.count) {
        SGFocusImageItem *item = [imageItems objectAtIndex:targetPage];
        //delegate 
        if (_delegate && [_delegate respondsToSelector:@selector(foucusImageFrame:didSelectItem:)]) {
            [_delegate foucusImageFrame:self didSelectItem:item];
        }
        
        //block
        if (_didSelectItemBlock) {
            _didSelectItemBlock(item);
        }
    }
}

#pragma mark - ScrollView MOve

- (void)moveToTargetPage:(NSInteger)targetPage
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    CGFloat targetX = targetPage * self.scrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
    [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:self.switchTimeInterval];
}

- (void)switchFocusImageItems
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    CGFloat targetX = self.scrollView.contentOffset.x + self.scrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
    
    if (self.autoScrolling) {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:self.switchTimeInterval];
    }
}

- (void)moveToTargetPosition:(CGFloat)targetX
{
    //NSLog(@"moveToTargetPosition : %f" , targetX);
    if (targetX >= self.scrollView.contentSize.width) {
        targetX = 0.0;
    }
    
    [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES] ;
    self.pageControl.currentPage = (int)(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
}

- (void)setAutoScrolling:(BOOL)enable
{
    _autoScrolling = enable;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    if (_autoScrolling) {
         [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:self.switchTimeInterval];
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
}

@end

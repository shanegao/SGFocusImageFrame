//
//  ViewController.m
//  SGFocusImageFrame
//
//  Created by Shane Gao on 17/6/12.
//  Copyright (c) 2012 Shane Gao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (void)setupViews;
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Demo";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Setup Views

- (void)setupViews
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    SGFocusImageItem *item1 = [[SGFocusImageItem alloc] initWithTitle:@"title1" image:[UIImage imageNamed:@"banner1"] tag:0];
    SGFocusImageItem *item2 = [[SGFocusImageItem alloc] initWithTitle:@"title2" image:[UIImage imageNamed:@"banner2"] tag:1];
    SGFocusImageItem *item3 = [[SGFocusImageItem alloc] initWithTitle:@"title3" image:[UIImage imageNamed:@"banner3"] tag:2];
    SGFocusImageItem *item4 = [[SGFocusImageItem alloc] initWithTitle:@"title4" image:[UIImage imageNamed:@"banner4"] tag:4];
    
    SGFocusImageFrame *bottomImageFrame = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 64.f, self.view.frame.size.width, 100.0) delegate:self focusImageItems:item1, item2, item3, item4, nil];
    bottomImageFrame.autoScrolling = YES;
    [self.view addSubview:bottomImageFrame];
    
    [self showGuidePictures];
}

- (void)showGuidePictures
{
    SGFocusImageItem *item1 = [[SGFocusImageItem alloc] initWithTitle:@"title1" image:[UIImage imageNamed:@"photo1.jpg"] tag:1001];
    SGFocusImageItem *item2 = [[SGFocusImageItem alloc] initWithTitle:@"title2" image:[UIImage imageNamed:@"photo2.jpg"] tag:1002];
    SGFocusImageItem *item3 = [[SGFocusImageItem alloc] initWithTitle:@"title3" image:[UIImage imageNamed:@"photo3.jpg"] tag:1003];
    SGFocusImageItem *item4 = [[SGFocusImageItem alloc] initWithTitle:@"title4" image:[UIImage imageNamed:@"photo4.jpg"] tag:1004];
    
    SGFocusImageFrame *imageFrame = [[SGFocusImageFrame alloc] initWithFrame:[[UIScreen mainScreen] bounds] delegate:nil focusImageItems:item1, item2, item3, item4, nil];
    __weak __typeof(&*imageFrame) weakImageFrame = imageFrame;
    imageFrame.didSelectItemBlock = ^(SGFocusImageItem *item) {
        NSLog(@"%@ tapped", item.title);
        if (item.tag == 1004) {
            [weakImageFrame removeFromSuperview];
        }
    };
    imageFrame.autoScrolling = NO;
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:imageFrame];
}

#pragma mark - SGFocusImageFrameDelegate

- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    NSLog(@"%@ tapped", item.title);
    
    if (item.tag == 1004) {
        [imageFrame removeFromSuperview];
    }
}
@end

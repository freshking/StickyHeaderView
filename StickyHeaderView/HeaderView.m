//
//  HeaderView.m
//  StickyHeaderView
//
//  Created by Bastian Kohlbauer on 15.03.14.
//  Copyright (c) 2014 Bastian Kohlbauer. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView ()
@property (nonatomic, strong) NSArray *imageNames;
@end

@implementation HeaderView

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
                
        _imageNames = [NSArray arrayWithObjects:@"iPhone1",@"iPhone2",@"iPhone3",@"iPhone4",@"iPhone5",@"iPhone6", nil];
        
        NSMutableArray *controllers = [[NSMutableArray alloc] init];
        for (unsigned i = 0; i < [_imageNames count]; i++) {
            [controllers addObject:[NSNull null]];
        }
        _viewControllers = controllers;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * [_imageNames count], _scrollView.frame.size.height);
        [_scrollView setBackgroundColor:[UIColor whiteColor]];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.autoresizesSubviews = YES;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        _isExpanded = NO;
        
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap)];
        singleFingerTap.numberOfTapsRequired = 1;
        [_scrollView addGestureRecognizer:singleFingerTap];
        
        _pageControl = [[UIPageControl alloc]initWithFrame: CGRectMake(0, self.frame.size.height-10, self.frame.size.width, 10)];
        _pageControl.numberOfPages = [_imageNames count];
        [_pageControl setBackgroundColor:[UIColor clearColor]];
        [_pageControl setUserInteractionEnabled:NO];
        [_pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
        if ([_imageNames count] > 1) [self addSubview:_pageControl];
        
        [self loadScrollViewWithPage:0];
        [self loadScrollViewWithPage:1];
    }
    return self;
}

#pragma mark - Private Mehods
- (void)updateFrame:(CGRect)rect
{
    self.frame = rect;
    _scrollView.frame = rect;
    
    float y = self.frame.size.height + _scrollView.frame.origin.y - 10.0f;
    _pageControl.frame = CGRectMake(0.0f, y, self.frame.size.width, 10.0f);
}

#pragma mark - UITapGestureRecognizer
- (void)didTap
{
    if ([_delegate respondsToSelector:@selector(toggleHeaderViewFrame)])
    {
        [_delegate performSelector:@selector(toggleHeaderViewFrame)];
    }
}

#pragma mark - Load ScrollView Pages
- (void)loadScrollViewWithPage:(int)page {
    
    if (page < 0) return;
    if (page >= [_imageNames count]) return;
    
    
    // replace the placeholder if necessary
    UIImageView *controller = [_viewControllers objectAtIndex:page];
    
    if ((NSNull *)controller == [NSNull null]) {
        
        controller = [[UIImageView alloc] init];
        CGRect frame = _scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.frame = frame;
        [controller setContentMode:UIViewContentModeScaleAspectFill];
        controller.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [controller.layer setMasksToBounds:YES];
        [_scrollView addSubview:controller];
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner setCenter:CGPointMake(controller.center.x, controller.center.y)];
        [spinner startAnimating];
        [controller addSubview:spinner];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            for (int i = 0; i < [_imageNames count]; i++) {
                
                if (page == i) { //set up each page
                    
                    [_viewControllers replaceObjectAtIndex:page withObject:controller];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [controller setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Resources.bundle/%@.png",[_imageNames objectAtIndex:i]]]];
                        [spinner removeFromSuperview];
                        
                        return;
                        
                    });
                }
            }
            
        });
        
    }
    
}

#pragma mark - ScrollView Methods
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (_pageControlUsed) {
        return;
    }
    
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}
// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _pageControlUsed = YES;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    _pageControlUsed = NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

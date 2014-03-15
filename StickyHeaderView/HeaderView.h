//
//  HeaderView.h
//  StickyHeaderView
//
//  Created by Bastian Kohlbauer on 15.03.14.
//  Copyright (c) 2014 Bastian Kohlbauer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView <UIScrollViewDelegate>

@property (assign, nonatomic) BOOL pageControlUsed;
@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

- (void)updateFrame:(CGRect)rect;

@end

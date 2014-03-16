//
//  HeaderView.h
//  StickyHeaderView
//
//  Created by Bastian Kohlbauer on 15.03.14.
//  Copyright (c) 2014 Bastian Kohlbauer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeaderViewDelegate <NSObject>
@optional
- (void)toggleHeaderViewFrame;
@end

@interface HeaderView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id <HeaderViewDelegate> delegate;
@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, assign) BOOL pageControlUsed;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

- (void)updateFrame:(CGRect)rect;

@end

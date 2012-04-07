//
//  DGPagedView.m
//
//  Created by Daniel García on 23/02/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

//Simple UIScrollView subclass that automatically handle UIPageControl and paged content
@interface DGScrollView : UIScrollView{
}
@property (nonatomic, assign) NSUInteger page; 
@property (nonatomic, retain) NSArray* views;
@property (nonatomic, retain) NSArray* contentViews;
@property (retain,nonatomic) UIPageControl* pageControl;
@property (nonatomic) BOOL pageControlHidden;
- (void) updatePageControlPosition;
- (void) setPage:(NSUInteger)page animated:(BOOL) animated;
- (void) addPage:(UIView*) view;
- (void) addPage:(UIView*) view atIndex:(NSUInteger) index;
- (void) removePage:(UIView*) view;
- (void) removePageAtIndex:(NSUInteger) index;
- (UIView *) pageAtIndex:(NSUInteger)index;
- (void) emptyPages;
@end

// DGPagedView Protocols
@protocol DGScrollViewDelegate <NSObject>
@required
- (void) didSelectPageAtIndex:(NSUInteger)index;
@end
@protocol DGScrollViewDataSource <NSObject>
@required
- (UIView *)pagedView:(id<DGScrollViewDelegate>)pagedView pageViewAtIndex:(NSUInteger)index;
- (NSInteger)numberOfPagesInPagedView:(id<DGScrollViewDelegate>) pagedView;
@end
//
//  DGPagedView.m
//
//  Created by Daniel García on 23/02/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGScrollView.h"

typedef enum {
    DGScrollViewReloadDataAnimationNone=0,
    DGScrollViewReloadDataAnimationFadeOutIn
}DGScrollViewReloadDataAnimation;

@interface DGPagedViewController : UIViewController<UIScrollViewDelegate,DGScrollViewDelegate,DGScrollViewDataSource>{
}
@property (nonatomic) CGRect frame;
@property (nonatomic,readonly) NSInteger currentPage;
@property (nonatomic,retain) DGScrollView* scrollView;
@property (nonatomic) BOOL pageControlHidden;
@property (retain,nonatomic) UIPageControl* pageControl;

- (void) setPage:(NSUInteger)page animated:(BOOL) animated;
- (void) reloadData;
- (void)reloadDataWithAnimation:(DGScrollViewReloadDataAnimation)animation;
- (void)reloadDataWithAnimation:(DGScrollViewReloadDataAnimation)animation withDuration:(float)duration;
//Data Source Methods
- (NSInteger)numberOfPagesInPagedView:(DGPagedViewController *)pagedView;
- (UIView *)pagedView:(DGPagedViewController *)pagedView pageViewAtIndex:(NSUInteger)index;
//Delegate Methods
- (void)didSelectPageAtIndex:(NSUInteger)index;
@end
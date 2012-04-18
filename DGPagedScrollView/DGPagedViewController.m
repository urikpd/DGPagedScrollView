//
//  DGPagedView.m
//
//  Created by Daniel García on 23/02/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "DGPagedViewController.h"
#define kPageControlBottomMargin 55.0f

typedef enum {
    DGScrollLeft=0,
    DGScrollRight
}DGScrollDirection;
@interface DGPagedViewController(){
    
}
@property (retain,nonatomic) UIView *zoomedView;
@property (nonatomic) NSInteger actualPage;
//- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView;
@end
@implementation DGPagedViewController
@synthesize scrollView,currentPage,actualPage,zoomedView,frame, pageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.actualPage=0;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
- (void)setPageControlHidden:(BOOL)hidden{
    self.scrollView.pageControlHidden=hidden;
}
- (BOOL)pageControlHidden{
    return self.scrollView.pageControlHidden;
}
#pragma mark - View lifecycle
- (void)loadView{
    [super loadView];
    CGRect viewFrame;
    if(!CGRectEqualToRect(self.frame, CGRectNull) && !CGRectEqualToRect(self.frame, CGRectZero))
        viewFrame=self.frame;
    else
        viewFrame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame=viewFrame;
    viewFrame.origin.x=0;
    viewFrame.origin.y=0;
    self.scrollView=[[[DGScrollView alloc] initWithFrame:viewFrame andSpaceBetweenPages:2]autorelease];    
    self.scrollView.delegate=self;
    self.scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.scrollView.minimumZoomScale = self.scrollView.frame.size.width / self.scrollView.frame.size.width;
    self.scrollView.maximumZoomScale = 2.0;
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale];
    [self.view insertSubview:self.scrollView atIndex:0];
    self.pageControl=self.scrollView.pageControl;
    CGRect pageControlFrame=self.pageControl.frame;
    pageControlFrame.origin.y=self.view.frame.size.height-pageControlFrame.size.height-kPageControlBottomMargin;
    self.pageControl.frame=pageControlFrame;
    [self.view insertSubview:pageControl atIndex:1];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadData];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [pageControl release];
    [zoomedView release];
    [scrollView release];
    [super dealloc];
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    static NSInteger previousPage = 0;
    NSInteger page=self.currentPage;
    if (previousPage != page && page>=0) {
        [self.scrollView updatePageControlPosition];
        DGScrollDirection direction;
        if(previousPage<page){
            direction=DGScrollRight;
        }else{
            direction=DGScrollLeft;
        }
        previousPage = page;
        self.actualPage=page;
        NSInteger totalPages = [self numberOfPagesInPagedView:self];
        if(direction==DGScrollRight){
            NSInteger indexToFree=page-2;
            if(indexToFree>=0){
                [self.scrollView removePageAtIndex:indexToFree];
            }
        }else{
            NSInteger indexToFree=page+3;
            if(indexToFree<totalPages){
                [self.scrollView removePageAtIndex:indexToFree];
            }
        }
    }
}
/*
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [self.scrollView pageAtIndex:self.currentPage];
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    [self.scrollView pageAtIndex:self.currentPage].frame = [self centeredFrameForScrollView:self.scrollView andUIView:[self.scrollView pageAtIndex:self.currentPage]];
}
- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView {
    CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
    return frameToCenter;
}
 */
- (NSInteger) currentPage{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    return page;
}
#pragma mark - DGPagedViewController DataSource
- (void)reloadData{
    [self.scrollView emptyPages];
    [self.scrollView layoutSubviews];
}

- (void)reloadDataWithAnimation:(BOOL)animated {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.scrollView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [self reloadData];
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.scrollView.alpha = 1.0f;
            } completion:NULL];
        }
    }];
    
}
- (NSInteger)numberOfPagesInPagedView:(DGPagedViewController *)pagedView{
    NSLog(@"%@ method must be implemented by the subclass",NSStringFromSelector(_cmd));
    [self doesNotRecognizeSelector:_cmd];
    return 0;
}
- (UIView *)pagedView:(DGPagedViewController *)pagedView pageViewAtIndex:(NSUInteger)index{
    NSLog(@"%@ method must be implemented by the subclass",NSStringFromSelector(_cmd));
    [self doesNotRecognizeSelector:_cmd];
    return 0;
}
#pragma mark - DGPagedViewController Delegate
- (void)didSelectPageAtIndex:(NSUInteger)index{
    NSLog(@"%@ method must be implemented by the subclass",NSStringFromSelector(_cmd));
    [self doesNotRecognizeSelector:_cmd];    
}
- (void) setPage:(NSUInteger)page animated:(BOOL) animated {
    [self.scrollView setPage:page animated:animated];
}

@end

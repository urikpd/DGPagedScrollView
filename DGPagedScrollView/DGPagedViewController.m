//
//  DGPagedView.m
//
//  Created by Daniel García on 23/02/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "DGPagedViewController.h"
typedef enum {
    DGScrollLeft=0,
    DGScrollRight
}DGScrollDirection;
@interface DGPagedViewController(){
    
}
@property (nonatomic) NSInteger actualPage;
@end
@implementation DGPagedViewController
@synthesize scrollView,currentPage,actualPage;

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
    self.scrollView=[[[DGScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
    self.scrollView.delegate=self;
    self.scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view insertSubview:self.scrollView atIndex:0];

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
    [scrollView release];
    [super dealloc];
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    static NSInteger previousPage = 0;
    NSInteger page=self.currentPage;
    if (previousPage != page && page>=0) {
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
- (NSInteger) currentPage{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    return page;
}
#pragma mark - DGPagedViewController DataSource
- (void)reloadData{
   [self.scrollView layoutSubviews];
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

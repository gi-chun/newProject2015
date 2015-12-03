//
//  completeViewController.m
//  gcleeEmpty
//
//  Created by gclee on 2015. 11. 18..
//  Copyright © 2015년 gclee. All rights reserved.
//

#import "completeViewController.h"
#import "NavigationBarView.h"

@interface completeViewController () <NavigationBarViewDelegate>
{
     NavigationBarView *navigationBarView;
    __weak IBOutlet UIButton *goBtn;
    __weak IBOutlet UILabel *labelWelcom;
}

@end

@implementation completeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(kScreenBoundsWidth > 320){
        if(kScreenBoundsWidth > 400){
            [self.view setBounds:CGRectMake(-kPopWindowMarginW*2, -30, self.view.bounds.size.width, self.view.bounds.size.height)];
        }else{
            [self.view setBounds:CGRectMake(-kPopWindowMarginW, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        }
        
    }
    
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        [self initScreenView_ko];
    }else{
        [self initScreenView_vi];
    }

    
    [self resetNavigationBarView:1];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self resetNavigationBarView:1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBtnClick:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - CPNavigationBarViewDelegate

- (void)resetNavigationBarView:(NSInteger) type
{
    [self.navigationItem setHidesBackButton:YES];
    
    for (UIView *subView in self.navigationController.navigationBar.subviews) {
        if ([subView isKindOfClass:[NavigationBarView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    [self.navigationController.navigationBar addSubview:[self navigationBarView:1]];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    
}

- (NavigationBarView *)navigationBarView:(NSInteger)navigationType
{
    
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeight) type:navigationType title:COMPLETE_TITLE_KO];
        [navigationBarView setDelegate:self];
    }else{
        navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeight) type:navigationType title:COMPLETE_TITLE_VI];
        [navigationBarView setDelegate:self];
    }
   
    
    return navigationBarView;
}

- (void)didTouchBackButton
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //    if ([self.delegate respondsToSelector:@selector(didTouchBackButton)]) {
    //        [self.delegate didTouchBackButton];
    //    }
}


#pragma mark -initScreenView
-(void)initScreenView_ko{
    
    [self resetNavigationBarView:1];
    [labelWelcom setText:WELCOM_DESC_KO];
    [goBtn setTitle:SERVICE_GO_KO forState:UIControlStateNormal];
    
}

-(void)initScreenView_vi{
    
    [self resetNavigationBarView:1];
    [labelWelcom setText:WELCOM_DESC_VI];
    [goBtn setTitle:SERVICE_GO_KO forState:UIControlStateNormal];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

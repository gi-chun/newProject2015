//
//  idResultViewController.m
//  gcleeEmpty
//
//  Created by gclee on 2015. 11. 25..
//  Copyright © 2015년 gclee. All rights reserved.
//

// version click image
// last version -> search_btn.png
// need update -> login_btn_small.png

#import "idResultViewController.h"
#import "NavigationBarView.h"
#import "LoginViewController.h"
#import "pwdSearchViewController.h"

@interface idResultViewController ()
{
     NavigationBarView *navigationBarView;
    
    __weak IBOutlet UILabel *resultDesc;
    __weak IBOutlet UILabel *emailLabel;
    __weak IBOutlet UILabel *resultTailLabel;
    
    __weak IBOutlet UIButton *btnLogin;
    __weak IBOutlet UIButton *btnPwdSearch;
    
    NSString* emailResult;
    
}
@end

@implementation idResultViewController

- (void)setId:(NSString*)email{
    
    [emailLabel setText:email];
    emailResult = email;
}

- (IBAction)loginClick:(id)sender {
    
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [loginViewController setDelegate:self];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (IBAction)pwdSearchClick:(id)sender {
    
    pwdSearchViewController *PwdSearchWiewController = [[pwdSearchViewController alloc] init];
    [PwdSearchWiewController setDelegate:self];
    [self.navigationController pushViewController:PwdSearchWiewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(kScreenBoundsWidth > 320){
        [self.view setBounds:CGRectMake(-kPopWindowMarginW, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    // Do any additional setup after loading the view from its nib.
    [self resetNavigationBarView:1];
    
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        
        NSString* temp;
        temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
        if([temp isEqualToString:@"ko"]){
            [self initScreenView_ko];
        }else if([temp isEqualToString:@"vi"]){
            [self initScreenView_vi];
        }else{
            temp = @"EN";
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/////////////////////////////////////////////////////////////////////
//navigation
#pragma mark - CPNavigationBarView
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
        navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeight) type:navigationType title:IDSEARCH_TITLE_KO];
        [navigationBarView setDelegate:self];
    }else{
        navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeight) type:navigationType title:IDSEARCH_TITLE_VI];
        [navigationBarView setDelegate:self];
    }
    
    
    return navigationBarView;
}

- (void)didTouchBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
    
    //    if ([self.delegate respondsToSelector:@selector(didTouchBackButton)]) {
    //        [self.delegate didTouchBackButton];
    //    }
}

#pragma mark -initScreenView
-(void)initScreenView_ko{
    
    [self resetNavigationBarView:1];
    [resultDesc setText:ID_RESULT_HEAD_KO];
    [emailLabel setText:emailResult];
    [resultTailLabel setText:ID_RESULT_TAIL_KO];
    
    [btnLogin setTitle:LOGIN_TITLE_KO forState:UIControlStateNormal];
    [btnPwdSearch setTitle:PW_SEARCH_TITLE_KO forState:UIControlStateNormal];
}

-(void)initScreenView_vi{
    
    [self resetNavigationBarView:1];
    [resultDesc setText:ID_RESULT_HEAD_VI];
    [emailLabel setText:emailResult];
    [resultTailLabel setText:ID_RESULT_TAIL_VI];
    
    [btnLogin setTitle:LOGIN_TITLE_VI forState:UIControlStateNormal];
    [btnPwdSearch setTitle:PW_SEARCH_TITLE_VI forState:UIControlStateNormal];

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

//
//  setAlramViewController.m
//  gcleeEmpty
//
//  Created by gclee on 2015. 11. 25..
//  Copyright © 2015년 gclee. All rights reserved.
//

#import "setAlramViewController.h"
#import "NavigationBarView.h"

@interface setAlramViewController ()
{
    __weak IBOutlet UILabel *labelTotalAlram;
    __weak IBOutlet UILabel *labelDesc;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *contentsLabel;
    __weak IBOutlet UILabel *eventLabel;
    
    __weak IBOutlet UISwitch *switchTotal;
    __weak IBOutlet UIButton *contentsButton;
    __weak IBOutlet UIButton *eventButton;
    
     NavigationBarView *navigationBarView;
}
@end

@implementation setAlramViewController

- (IBAction)totalSwitchClick:(id)sender {
    BOOL isTuto = [[NSUserDefaults standardUserDefaults] boolForKey:kPushY];
    if(isTuto == YES){
        [switchTotal setOn:false];
    }else{
        [switchTotal setOn:true];
    }
}

- (IBAction)contentsBtnClick:(id)sender {
    
    BOOL isTuto = [[NSUserDefaults standardUserDefaults] boolForKey:kContentsPushY];
    if(isTuto == YES){
        //set no
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kContentsPushY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //contentsButton setImage:<#(UIImage *)#> forState:<#(UIControlState)#>
        
    }else{
        //set yes
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kContentsPushY];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
}

- (IBAction)eventBtnClick:(id)sender {
    
    BOOL isTuto = [[NSUserDefaults standardUserDefaults] boolForKey:kEventPushY];
    if(isTuto == YES){
        //set no
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kEventPushY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{
        //set yes
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kEventPushY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    float meHeight = kScreenBoundsHeight;
    if(meHeight <= 480){
        UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                     initWithTarget:self action:@selector(handlePanGesture:)];
        [self.view addGestureRecognizer:gestureRecognizer];
        self.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+kToolBarHeight+10+10);
    }
    
    CGFloat marginX = 0;
    
    if(kScreenBoundsWidth > 320){
        if(kScreenBoundsWidth > 400){
            [self.view setBounds:CGRectMake(-kPopWindowMarginW*2, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            marginX = kPopWindowMarginW*2;
        }else{
            [self.view setBounds:CGRectMake(-kPopWindowMarginW, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            marginX = kPopWindowMarginW;
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
    
    //
    if(meHeight > 480){
        NSString* strImage;
        temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
        if([temp isEqualToString:@"ko"]){
            strImage = BOTTOM_BANNER_KO;
        }else{
            strImage = BOTTOM_BANNER_VI;
        }
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-marginX, kScreenBoundsHeight-(kToolBarHeight+15), kScreenBoundsWidth, kToolBarHeight)];
        [backgroundImageView setImage:[UIImage imageNamed:strImage]];
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill; //UIViewContentModeScaleAspectFit
        [self.view addSubview:backgroundImageView];
        
        NSURL *imageURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:kLeftMainBannerImgUrl]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                backgroundImageView.image = [UIImage imageWithData:imageData];
            });
        });
        
        UIButton *adButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [adButton setFrame:CGRectMake(-marginX, kScreenBoundsHeight-(kToolBarHeight+15), kScreenBoundsWidth, kToolBarHeight)];
        [adButton setBackgroundColor:[UIColor clearColor]];
        [adButton addTarget:self action:@selector(touchToolbar:) forControlEvents:UIControlEventTouchUpInside];
        //[adButton setTag:2];
        [self.view addSubview:adButton];
        
    }else{
        NSString* strImage;
        temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
        if([temp isEqualToString:@"ko"]){
            strImage = BOTTOM_BANNER_KO;
        }else{
            strImage = BOTTOM_BANNER_VI;
        }
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-marginX, self.view.bounds.size.height+10, kScreenBoundsWidth, kToolBarHeight)];
        [backgroundImageView setImage:[UIImage imageNamed:strImage]];
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill; //UIViewContentModeScaleAspectFit
        [self.view addSubview:backgroundImageView];
        
        NSURL *imageURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:kLeftMainBannerImgUrl]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                backgroundImageView.image = [UIImage imageWithData:imageData];
            });
        });
        
        UIButton *adButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [adButton setFrame:CGRectMake(-marginX, self.view.bounds.size.height+10, kScreenBoundsWidth, kToolBarHeight)];
        [adButton setBackgroundColor:[UIColor clearColor]];
        [adButton addTarget:self action:@selector(touchToolbar:) forControlEvents:UIControlEventTouchUpInside];
        //[adButton setTag:2];
        [self.view addSubview:adButton];
    }
}

- (void)touchToolbar:(id)sender
{
    //UIButton *button = (UIButton *)sender;
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(didTouchMainAD)]) {
        [self.delegate didTouchMainAD];
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
    NSString* title;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        title = SET_PUSH_SET_TITLE_KO;
    }else{
        title = SET_PUSH_SET_TITLE_VI;
    }
    navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeight) type:navigationType title:title];
    [navigationBarView setDelegate:self];
    
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
    
    [labelTotalAlram setText:SET_PUSH_TOTAL_KO];
    [labelDesc setText:SET_PUSH_DESC_KO];
    [titleLabel setText:SET_PUSH_SET_TITLE_KO];
    [contentsLabel setText:SET_PUSH_CONTENTS_KO];
    [eventLabel setText:SET_PUSH_EVENT_KO];
    
}

-(void)initScreenView_vi{
    
    [self resetNavigationBarView:1];
    
    [labelTotalAlram setText:SET_PUSH_TOTAL_VI];
    [labelDesc setText:SET_PUSH_DESC_VI];
    [titleLabel setText:SET_PUSH_SET_TITLE_VI];
    [contentsLabel setText:SET_PUSH_CONTENTS_VI];
    [eventLabel setText:SET_PUSH_EVENT_VI];
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

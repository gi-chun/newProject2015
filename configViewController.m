//
//  configViewController.m
//  gcleeEmpty
//
//  Created by gclee on 2015. 11. 18..
//  Copyright © 2015년 gclee. All rights reserved.
//


#import "configViewController.h"
#import "personModifyViewController.h"
#import "myPickerViewController.h"
#import "LoginViewController.h"
#import "leftViewController.h"
#import "Appdelegate.h"
#import "setAlramViewController.h"
#import "AFHTTPRequestOperation.h"
#import "SBJson.h"
#import "AFHTTPRequestOperationManager.h"

@interface configViewController () <NavigationBarViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *needLabel;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *realMainView;
@property (weak, nonatomic) IBOutlet UIScrollView *realScrollView;
@property (weak, nonatomic) IBOutlet UILabel *langLabel;
@property (weak, nonatomic) IBOutlet UILabel *L_HELP_KO;
@property (weak, nonatomic) IBOutlet UILabel *L_TUTO_KO;
@property (weak, nonatomic) IBOutlet UILabel *L_NEW;
@property (weak, nonatomic) IBOutlet UILabel *L_ALRAM_SET_KO;
@property (weak, nonatomic) IBOutlet UILabel *LALRAM_ALLOW_KO;
@property (weak, nonatomic) IBOutlet UILabel *LALRAM_DES_KO;
@property (weak, nonatomic) IBOutlet UILabel *LPROGRAM_INFO_KO;
@property (weak, nonatomic) IBOutlet UILabel *LLANG_INFO_KO;
@property (weak, nonatomic) IBOutlet UILabel *LAPP_INFO_KO;
@property (weak, nonatomic) IBOutlet UILabel *LCURR_VER_KO;
@property (weak, nonatomic) IBOutlet UILabel *curVerLabel;
@property (weak, nonatomic) IBOutlet UILabel *LNEW_VER_KO;
@property (weak, nonatomic) IBOutlet UILabel *lastVerLabel;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (weak, nonatomic) IBOutlet UISwitch *tutoBtn;
@property (weak, nonatomic) IBOutlet UISwitch *pushBtn;
@property (weak, nonatomic) IBOutlet UILabel *sunnyDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnAlam;

@end

@implementation configViewController

- (IBAction)btnAlramClick:(id)sender {
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kLoginY];
    if(isLogin == YES){
        setAlramViewController *setAlramController = [[setAlramViewController alloc] init];
        [setAlramController setDelegate:self];
        [self.navigationController pushViewController:setAlramController animated:YES];
    }else{
        LoginViewController *loginController = [[LoginViewController alloc] init];
        [loginController setLoginType:LoginTypeConfig];
        [loginController setDelegate:self];
        [self.navigationController pushViewController:loginController animated:YES];
    }
}

- (IBAction)personalChange:(id)sender {
    
    float meHeight = kScreenBoundsHeight;
    if(meHeight <= 480){
        [self.view setBounds:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    }

    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kLoginY];
    if(isLogin == YES){
        personModifyViewController *personController = [[personModifyViewController alloc] init];
        [personController setDelegate:self];
        [self.navigationController pushViewController:personController animated:YES];
    }else{
        LoginViewController *loginController = [[LoginViewController alloc] init];
        [loginController setLoginType:LoginTypeConfig];
        [loginController setDelegate:self];
        [self.navigationController pushViewController:loginController animated:YES];
    }
    
}
- (IBAction)langBtnClick:(id)sender {
    
    myPickerViewController *myPickerController = [[myPickerViewController alloc] init];
    [myPickerController setDelegate:self];
    
    //[myPickerController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:myPickerController animated:YES completion:nil];
    
}
- (IBAction)newsViewClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didTouchNewButton)]) {
        [self.delegate didTouchNewButton];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)tutoBtn:(id)sender {
    
    if ([_tutoBtn isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kTutoY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kTutoY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

- (IBAction)helpViewClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didTouchHelpButton)]) {
        [self.delegate didTouchHelpButton];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didLoginAfter
{
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kLoginY];
    if(isLogin == YES){
        
        NSString* temp;
        temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
        if([temp isEqualToString:@"ko"]){
              [_needLabel setText:NEED_KO];
        }else if([temp isEqualToString:@"vi"]){
              [_needLabel setText:NEED_VI];
        }else{
              //[_needLabel setText:NEED_KO];
        }
        [_emailLabel setText:[[NSUserDefaults standardUserDefaults] stringForKey:kEmail]];
        
    }
}

- (IBAction)pushBtnClick:(id)sender {
    
    if ([_pushBtn isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kPushY];
        [[NSUserDefaults standardUserDefaults] synchronize];
  
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kPushY];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
}

- (IBAction)updateBtnClick:(id)sender {
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:kUpdateVersion] != nil){
        
        NSString *strUpdateUri = [[NSUserDefaults standardUserDefaults] stringForKey:kUpdateUri];
        //NSString *iTunesLink = @"https://itunes.apple.com/us/app/apple-store/id375380948?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUpdateUri]];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{

    if(kScreenBoundsWidth > 320){
        if(kScreenBoundsWidth > 400){
            [self.view setBounds:CGRectMake(-kPopWindowMarginW*2, -30, self.view.bounds.size.width, self.view.bounds.size.height)];
        }else{
            [self.view setBounds:CGRectMake(-kPopWindowMarginW, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        }
        
    }

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isChangeLang = 0;
    
//    for (UIView *subView in [self.view subviews]) {
//        [subView removeFromSuperview];
//    }
    
//    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"configViewController"
//                                                    owner:self options:nil];
//    Blah *blah;
//    for (id object in bundle) {
//        if ([object isKindOfClass:[Blah class]]) {
//            blah = (Blah *)object;
//            break;
//        }
//    }
//    assert(blah != nil && "blah can't be nil");
//    [self.view addSubview: blah];
    
    float meHeight = kScreenBoundsHeight;
    if(meHeight <= 480){
        UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                     initWithTarget:self action:@selector(handlePanGesture:)];
        [self.view addGestureRecognizer:gestureRecognizer];
        self.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+kToolBarHeight+10+10);
    }
    
//    [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:kFirstExecY];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    CGFloat marginX = 0;
    CGFloat marginY = 0;
    
    if(kScreenBoundsWidth > 320){
        if(kScreenBoundsWidth > 400){
            [self.view setBounds:CGRectMake(-kPopWindowMarginW*2, -30, self.view.bounds.size.width, self.view.bounds.size.height)];
            marginX = kPopWindowMarginW*2;
            marginY = 30;
        }else{
            [self.view setBounds:CGRectMake(-kPopWindowMarginW, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            marginX = kPopWindowMarginW;
        }
    }
//    for (UIView *subView in [self.view subviews]) {
//        [subView setBackgroundColor:UIColorFromRGB(0xffffff)];
//    }
//    
//    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        [self initScreenView_ko];
    }else if([temp isEqualToString:@"vi"]){
        [self initScreenView_vi];
    }else{
        temp = @"EN";
    }

    [self resetNavigationBarView:1];
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kLoginY];
    if(isLogin == YES){
        _emailLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:kEmail];
    }
    
    BOOL isTuto = [[NSUserDefaults standardUserDefaults] boolForKey:kTutoY];
    if(isTuto == YES){
        [_tutoBtn setOn:true];
    }
    
    // Do any additional setup after loading the view from its nib.
//    self.
//    for (UIView *subView in self.view) {
//        
//        if ([subView isKindOfClass:[NavigationBarView class]]) {
//            [subView removeFromSuperview];
//        }
//    }

//    CGFloat marginY = (kScreenBoundsWidth > 320)?100:0;
//    [self.mainView setFrame:CGRectMake(0+marginY, 0+marginY, kScreenBoundsWidth, kScreenBoundsHeight-marginY)];
////    [self.myScrollView setFrame:CGRectMake(0,0+marginY,kScreenBoundsWidth, kScreenBoundsHeight-marginY)];
//    
//    [self.myScrollView addSubview:self.contentView];
//    self.myScrollView.contentSize = self.contentView.frame.size;
//    self.myScrollView.contentSize = CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height+100);
//    //((UIScrollView *)self.view).contentSize = self.contentView.frame.size;
    
    //
    meHeight = kScreenBoundsHeight;
    if(meHeight > 480){
        NSString* strImage;
        temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
        if([temp isEqualToString:@"ko"]){
            strImage = BOTTOM_BANNER_KO;
        }else{
            strImage = BOTTOM_BANNER_VI;
        }
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-marginX, kScreenBoundsHeight-(kToolBarHeight+15+marginY), kScreenBoundsWidth, kToolBarHeight)];
        //[backgroundImageView setImage:[UIImage imageNamed:strImage]];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill; //UIViewContentModeScaleAspectFit
        [self.view addSubview:_backgroundImageView];
        
        NSURL *imageURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:kMainBannerImgUrl]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                _backgroundImageView.image = [UIImage imageWithData:imageData];
                if([imageData length] < 1){
                    [_backgroundImageView setImage:[UIImage imageNamed:strImage]];
                }
            });
        });
        
        UIButton *adButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [adButton setFrame:CGRectMake(-marginX, kScreenBoundsHeight-(kToolBarHeight+15+marginY), kScreenBoundsWidth, kToolBarHeight)];
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
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-marginX, self.view.bounds.size.height+10, kScreenBoundsWidth, kToolBarHeight)];
        //[backgroundImageView setImage:[UIImage imageNamed:strImage]];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill; //UIViewContentModeScaleAspectFit
        [self.view addSubview:_backgroundImageView];
        
        NSURL *imageURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:kMainBannerImgUrl]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                _backgroundImageView.image = [UIImage imageWithData:imageData];
                if([imageData length] < 1){
                    [_backgroundImageView setImage:[UIImage imageNamed:strImage]];
                }
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

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    CGRect bounds = self.view.bounds;
    
//    if(_isChangeLang){
//        bounds.origin.y += 120; //180
//    }
    
//    if( translation.y > 0){
//        translation.y = translation.y - 25;
//    }
    
    NSLog(@"pan-bounds:   x:%f, y:%f", bounds.origin.x, bounds.origin.y);
    NSLog(@"trans-bounds: x:%f, y:%f", translation.x, translation.y);

    // Translate the view's bounds, but do not permit values that would violate contentSize
    CGFloat newBoundsOriginX = bounds.origin.x - translation.x;
    CGFloat minBoundsOriginX = 0.0;
    CGFloat maxBoundsOriginX = self.contentSize.width - bounds.size.width;
    bounds.origin.x = fmax(minBoundsOriginX, fmin(newBoundsOriginX, maxBoundsOriginX));
    
    CGFloat newBoundsOriginY = bounds.origin.y - translation.y;
    CGFloat minBoundsOriginY = 0.0;
    CGFloat maxBoundsOriginY = self.contentSize.height - bounds.size.height;
    bounds.origin.y = fmax(minBoundsOriginY, fmin(newBoundsOriginY, maxBoundsOriginY));
    
    self.view.bounds = bounds;
    [gestureRecognizer setTranslation:CGPointZero inView:self.view];
}


- (void)touchToolbar:(id)sender
{
    //UIButton *button = (UIButton *)sender;
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(didTouchMainAD)]) {
        [self.delegate didTouchMainAD];
    }
}

- (void)didTouchMainAD{
    if ([self.delegate respondsToSelector:@selector(didTouchMainAD)]) {
        [self.delegate didTouchMainAD];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    CGFloat marginX = (kScreenBoundsWidth > 320)?60:0;
    CGFloat marginY = (kScreenBoundsWidth > 320)?70:150;
    
//    if(kScreenBoundsWidth > 320){
//        
//        [self.realScrollView addSubview:self.contentView];
//        self.realScrollView.contentSize = self.contentView.frame.size;
//        self.realScrollView.contentSize = CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height);
//        
//        [self.realMainView addSubview:self.realScrollView];
//        
//        [self.mainView addSubview:self.realMainView];
//        [self.realMainView setFrame:CGRectMake(0+marginX, 0+marginY, kScreenBoundsWidth, kScreenBoundsHeight-marginY)];
//        
//        for (UIView *subView in [self.view subviews]) {
//            [subView setBackgroundColor:UIColorFromRGB(0xffffff)];
//        }
//        
//        [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
//
//    }else{
    
        //CGFloat marginY = (kScreenBoundsWidth > 320)?100:0;
        //[self.mainView setFrame:CGRectMake(0+marginY, 0+marginY, kScreenBoundsWidth, kScreenBoundsHeight-marginY)];
        //    [self.myScrollView setFrame:CGRectMake(0,0+marginY,kScreenBoundsWidth, kScreenBoundsHeight-marginY)];
//        [self.myScrollView setBounces:false];
//        [self.myScrollView addSubview:self.contentView];
//        self.myScrollView.contentSize = CGSizeMake(kScreenBoundsWidth, self.contentView.frame.size.height+150);
//        self.myScrollView.contentSize = CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height+150);
        //((UIScrollView *)self.view).contentSize = self.contentView.frame.size;
        
//    }
    
    
    /* last
    if(kScreenBoundsWidth > 400){
        [self.myScrollView setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height+40)];
        [self.myScrollView setBounces:false];
        [self.myScrollView addSubview:self.contentView];
        self.myScrollView.contentSize = CGSizeMake(kScreenBoundsWidth-marginX*2, self.contentView.frame.size.height+marginY);
    }else{
        [self.myScrollView setBounces:false];
        [self.myScrollView addSubview:self.contentView];
        self.myScrollView.contentSize = CGSizeMake(kScreenBoundsWidth-marginX, self.contentView.frame.size.height+marginY);
    }
     */
    
    
    
    [self resetNavigationBarView:1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    /*
     - (void)viewDidLoad {
     [super viewDidLoad];
     [self.view addSubview:self.contentView];
     ((UIScrollView *)self.view).contentSize = self.contentView.frame.size;
     }

     - (void)viewDidUnload {
     self.contentView = nil;
     [super viewDidUnload];
     }
     
     */
}

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
        _navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeight) type:navigationType title:CONFIG_KO];
        [_navigationBarView setDelegate:self];
    }else if([temp isEqualToString:@"vi"]){
        _navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeight) type:navigationType title:CONFIG_VI];
        [_navigationBarView setDelegate:self];
    }else{
        temp = @"EN";
    }
    
    return _navigationBarView;
}

#pragma mark - CPNavigationBarViewDelegate

- (void)didTouchBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
    
//    if ([self.delegate respondsToSelector:@selector(didTouchBackButton)]) {
//        [self.delegate didTouchBackButton];
//    }
}

#pragma mark - delegate button
- (void)didTouchHelpButton
{
    
}

- (void)didTouchNewButton
{
   
    
}

#pragma mark -initScreenView
-(void)initScreenView_ko{
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kLoginY];
    if(isLogin == YES){
        [_needLabel setText:NEED_KO];
        [_emailLabel setText:[[NSUserDefaults standardUserDefaults] stringForKey:kEmail]];
    }else{
        [_needLabel setText:NEED_LOGIN_KO];
        [_emailLabel setText:@""];
    }
    
    [_L_HELP_KO setText:HELP_KO];
    [_L_TUTO_KO setText:TUTO_KO];
    BOOL isTuto = [[NSUserDefaults standardUserDefaults] boolForKey:kTutoY];
    if(isTuto == YES){
        [_tutoBtn setOn:true];
    }else{
        [_tutoBtn setOn:false];
    }
    
    [_L_NEW setText:NEWS_KO];
    [_L_ALRAM_SET_KO setText:ALRAM_SET_KO];
    [_LALRAM_ALLOW_KO setText:ALRAM_ALLOW_KO];
    [_LALRAM_DES_KO setText:ALRAM_DES_KO];
    
    BOOL isAlram = [[NSUserDefaults standardUserDefaults] boolForKey:kPushY];
    if(isAlram == YES){
        [_pushBtn setOn:true];
    }else{
        [_pushBtn setOn:false];
    }
    
    [_LPROGRAM_INFO_KO setText:PROGRAM_INFO_KO];
    [_LLANG_INFO_KO setText:LANG_INFO_KO];
    
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        temp = @"KOREA";
    }else if([temp isEqualToString:@"vi"]){
        temp = @"VIETNAMESE";
    }else{
        temp = @"EN";
    }
    [_langLabel setText:temp];
    
    [_LAPP_INFO_KO setText:APP_INFO_KO];
    [_LCURR_VER_KO setText:CURR_VER_KO];
    [_LNEW_VER_KO setText:NEW_VER_KO];
    
    NSString* curVertemp = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentVersion];
    [_curVerLabel setText:curVertemp];
    curVertemp = [curVertemp stringByReplacingOccurrencesOfString:@"." withString:@""];
    int nCurVer, nUpVer;
    nCurVer = [curVertemp intValue];
    
    NSString* updateVertemp = [[NSUserDefaults standardUserDefaults] stringForKey:kUpdateVersion];
    if([updateVertemp isEqualToString:@""]){
        [_lastVerLabel setText:curVertemp];
    }else{
        [_lastVerLabel setText:updateVertemp];
    }
    
    updateVertemp = [updateVertemp stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    nUpVer = [updateVertemp intValue];
   
    if(nCurVer >= nUpVer){
        [_updateBtn setEnabled:false];
        [_updateBtn setBackgroundImage:[UIImage imageNamed:@"search_btn.png"] forState:UIControlStateNormal];
        [_updateBtn setTitle:LAST_VER_KO forState:UIControlStateNormal];
        
    }else{
        [_updateBtn setEnabled:true];
        [_updateBtn setBackgroundImage:[UIImage imageNamed:@"home_btn.png"] forState:UIControlStateNormal];
        [_updateBtn setTitle:LAST_VER_UP_KO forState:UIControlStateNormal];
    }
    
    [_sunnyDescLabel setText:SUNNY_DES_KO];
    [self resetNavigationBarView:1];
    
}

-(void)initScreenView_vi{
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kLoginY];
    if(isLogin == YES){
        [_needLabel setText:NEED_VI];
        [_emailLabel setText:[[NSUserDefaults standardUserDefaults] stringForKey:kEmail]];
    }else{
        [_needLabel setText:NEED_LOGIN_VI];
        [_emailLabel setText:@""];
    }
    
    [_L_HELP_KO setText:HELP_VI];
    [_L_TUTO_KO setText:TUTO_VI];
    BOOL isTuto = [[NSUserDefaults standardUserDefaults] boolForKey:kTutoY];
    if(isTuto == YES){
        [_tutoBtn setOn:true];
    }else{
        [_tutoBtn setOn:false];
    }
    
    [_L_NEW setText:NEWS_VI];
    [_L_ALRAM_SET_KO setText:ALRAM_SET_VI];
    [_LALRAM_ALLOW_KO setText:ALRAM_ALLOW_VI];
    [_LALRAM_DES_KO setText:ALRAM_DES_VI];
    
    BOOL isAlram = [[NSUserDefaults standardUserDefaults] boolForKey:kPushY];
    if(isAlram == YES){
        [_pushBtn setOn:true];
    }else{
        [_pushBtn setOn:false];
    }
    
    [_LPROGRAM_INFO_KO setText:PROGRAM_INFO_VI];
    [_LLANG_INFO_KO setText:LANG_INFO_VI];
    
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        temp = @"KOREA";
    }else if([temp isEqualToString:@"vi"]){
        temp = @"VIETNAMESE";
    }else{
        temp = @"EN";
    }
    [_langLabel setText:temp];
    
    [_LAPP_INFO_KO setText:APP_INFO_VI];
    [_LCURR_VER_KO setText:CURR_VER_VI];
    [_LNEW_VER_KO setText:NEW_VER_VI];
    
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentVersion];
    [_curVerLabel setText:temp];
    temp = [temp stringByReplacingOccurrencesOfString:@"." withString:@""];
    int nCurVer, nUpVer;
    nCurVer = [temp intValue];
    
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:kUpdateVersion];
    [_lastVerLabel setText:temp];
    temp = [temp stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    nUpVer = [temp intValue];
    
    if(nCurVer >= nUpVer){
        [_updateBtn setEnabled:false];
        [_updateBtn setBackgroundImage:[UIImage imageNamed:@"search_btn.png"] forState:UIControlStateNormal];
        [_updateBtn setTitle:LAST_VER_VI forState:UIControlStateNormal];
        
    }else{
        [_updateBtn setEnabled:true];
        [_updateBtn setBackgroundImage:[UIImage imageNamed:@"home_btn.png"] forState:UIControlStateNormal];
        [_updateBtn setTitle:LAST_VER_UP_VI forState:UIControlStateNormal];
    }
    
    [_sunnyDescLabel setText:SUNNY_DES_VI];
    self.navigationBarView.title = CONFIG_VI;
    
    [self resetNavigationBarView:1];
    
    
}


#pragma mark -picker
- (void)didTouchPicker{
    
//    if(kScreenBoundsWidth > 320){
//        if(kScreenBoundsWidth > 400){
//            [self.view setBounds:CGRectMake(-kPopWindowMarginW*2, -30, self.view.bounds.size.width, self.view.bounds.size.height)];
//        }else{
//            [self.view setBounds:CGRectMake(-kPopWindowMarginW, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//        }
//        
//    }
    
    [self.view setBounds:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    _isChangeLang = 1;
    
    NSInteger nKind;
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    
    if([temp isEqualToString:@"ko"]){
        temp = @"KOREA";
        nKind = 0;
    }else if([temp isEqualToString:@"vi"]){
        temp = @"VIETNAMESE";
        nKind = 1;
    }else{
        nKind = 2;
        temp = @"EN";
    }
    
    [_langLabel setText:temp];
    
    [self getListBanner];
    
    if(![_preLang isEqualToString:temp] || _preLang == nil){
        if( nKind == 0){
             [self initScreenView_ko];
        }else{
            [self initScreenView_vi];
        }
    }
    _preLang = temp;
    
}

- (void) resetBanner{
    
    NSString* temp;
    NSString* strImage;
    
    float meHeight = kScreenBoundsHeight;
    if(meHeight <= 480){
        
//        UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc]
//                                                     initWithTarget:self action:@selector(handlePanGesture:)];
//        [self.view addGestureRecognizer:gestureRecognizer];
//        self.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+kToolBarHeight+10+10);
        
        //[self viewDidLoad];
        temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
        if([temp isEqualToString:@"ko"]){
            strImage = BOTTOM_BANNER_KO;
        }else{
            strImage = BOTTOM_BANNER_VI;
        }
        
        NSURL *imageURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:kMainBannerImgUrl]];
        
        NSLog(@"bannerURL: %@", imageURL);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                _backgroundImageView.image = [UIImage imageWithData:imageData];
                if([imageData length] < 1){
                    [_backgroundImageView setImage:[UIImage imageNamed:strImage]];
                }
            });
        });
        
        //[self.view setBounds:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        //[_backgroundImageView setFrame:CGRectMake(0, kScreenBoundsHeight+180, kScreenBoundsWidth, kToolBarHeight)];
        
        
    }else{
        
        temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
        if([temp isEqualToString:@"ko"]){
            strImage = BOTTOM_BANNER_KO;
        }else{
            strImage = BOTTOM_BANNER_VI;
        }
        
        NSURL *imageURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:kMainBannerImgUrl]];
        
        NSLog(@"bannerURL: %@", imageURL);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                _backgroundImageView.image = [UIImage imageWithData:imageData];
                if([imageData length] < 1){
                    [_backgroundImageView setImage:[UIImage imageNamed:strImage]];
                }
            });
        });
    }
    
    leftViewController *leftViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).gLeftViewController;
    [leftViewController setViewLogin];
    
    WebViewController *homeViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).homeWebViewController;
    [homeViewController resetADImage];
}

- (void) getListBanner{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *rootDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *indiv_infoDic = [NSMutableDictionary dictionary];
    
    NSString* temp;
    NSString* strDesc;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    //
    [rootDic setObject:COMMON_TASK_USR forKey:@"task"];
    [rootDic setObject:@"getListBanner" forKey:@"action"];
    [rootDic setObject:@"" forKey:@"serviceCode"];
    [rootDic setObject:@"" forKey:@"requestMessage"];
    [rootDic setObject:@"" forKey:@"responseMessage"];
    
    [indiv_infoDic setObject:@"2" forKey:@"d_1"];
    [indiv_infoDic setObject:temp forKey:@"language"];
    
    [sendDic setObject:rootDic forKey:@"root_info"];
    [sendDic setObject:indiv_infoDic forKey:@"indiv_info"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonString = [jsonWriter stringWithObject:sendDic];
    NSLog(@"request json: %@", jsonString);
    
    NSDictionary *parameters = @{@"plainJSON": jsonString};
    
    
    
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *allCookies = [cookies cookies];
    for(NSHTTPCookie *cookie in allCookies) {
        if([cookie.name isEqualToString:@"locale_"]){
            [cookies deleteCookie:cookie];
        }
        
        if([cookie.name isEqualToString:@"locale_80"]){
            [cookies deleteCookie:cookie];
        }
        
    }
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSHTTPCookie *cookie;
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"locale_" forKey:NSHTTPCookieName];
    [cookieProperties setObject:temp forKey:NSHTTPCookieValue];
    [cookieProperties setObject:COOKIE_SAVE_DOMAIN forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:COOKIE_SAVE_DOMAIN forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    // set expiration to one month from now
    [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    NSMutableDictionary *cookieProperties_ = [NSMutableDictionary dictionary];
    [cookieProperties_ setObject:@"locale_80" forKey:NSHTTPCookieName];
    [cookieProperties_ setObject:temp forKey:NSHTTPCookieValue];
    [cookieProperties_ setObject:COOKIE_SAVE_DOMAIN forKey:NSHTTPCookieDomain];
    [cookieProperties_ setObject:COOKIE_SAVE_DOMAIN forKey:NSHTTPCookieOriginURL];
    [cookieProperties_ setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties_ setObject:@"0" forKey:NSHTTPCookieVersion];
    // set expiration to one month from now
    [cookieProperties_ setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    cookie = [NSHTTPCookie cookieWithProperties:cookieProperties_];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    for (cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        NSLog(@"%@=%@", cookie.name, cookie.value);
    }
    
    NSLog(@"cooke end end");
    
    [manager POST:API_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSString *responseData = (NSString*) responseObject;
        NSArray *jsonArray = (NSArray *)responseData;
        NSDictionary * dicResponse = (NSDictionary *)responseData;
        
        //warning
        NSDictionary *dicItems = [dicResponse objectForKey:@"WARNING"];
        
        if(dicItems){
            NSString* sError = dicItems[@"msg"];
            NSLog(@"error ==> %@", sError);
            
        }else{
            
            NSMutableArray *_arrItems;
            _arrItems = nil;
            if(![dicResponse objectForKey:@"indiv_info"]){
                return ;
            }
            _arrItems = [dicResponse objectForKey:@"indiv_info"];
            if([_arrItems count] < 2){
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kLeftMainBannerImgUrl];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kLeftMainBannerUrl];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kMainBannerImgUrl];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kMainBannerUrl];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self resetBanner];
                return;
            }
            NSDictionary *dicChildOne = _arrItems[0];
            NSDictionary *dicChildTwo = _arrItems[1];
            
            NSString *temp;
            temp = [dicChildOne objectForKey:@"image"];
            temp = [NSString stringWithFormat:@"%@%@", SUNNY_DOMAIN, temp];
            [[NSUserDefaults standardUserDefaults] setObject:temp forKey:kLeftMainBannerImgUrl];
            [[NSUserDefaults standardUserDefaults] synchronize];
            temp = [dicChildOne objectForKey:@"url"];
            if(([temp rangeOfString:@"http"].location == NSNotFound)){
                temp = [NSString stringWithFormat:@"%@%@", SUNNY_DOMAIN, temp];
            }
            [[NSUserDefaults standardUserDefaults] setObject:temp forKey:kLeftMainBannerUrl];
            [[NSUserDefaults standardUserDefaults] synchronize];
            temp = [dicChildTwo objectForKey:@"image"];
            temp = [NSString stringWithFormat:@"%@%@", SUNNY_DOMAIN, temp];
            [[NSUserDefaults standardUserDefaults] setObject:temp forKey:kMainBannerImgUrl];
            [[NSUserDefaults standardUserDefaults] synchronize];
            temp = [dicChildTwo objectForKey:@"url"];
            if(([temp rangeOfString:@"http"].location == NSNotFound)){
                temp = [NSString stringWithFormat:@"%@%@", SUNNY_DOMAIN, temp];
            }
            [[NSUserDefaults standardUserDefaults] setObject:temp forKey:kMainBannerUrl];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self resetBanner];
            NSLog(@"Response ==> %@", responseData);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
    
    
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

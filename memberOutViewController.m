//
//  memberOutViewController.m
//  gcleeEmpty
//
//  Created by gclee on 2015. 11. 21..
//  Copyright © 2015년 gclee. All rights reserved.
//

#import "memberOutViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SBJson.h"
#import "NavigationBarView.h"
#import "leftViewController.h"
#import "AppDelegate.h"


@interface memberOutViewController () <NavigationBarViewDelegate>{
    
    NavigationBarView *navigationBarView;
    UITextField* currentEditingTextField;
    
    __weak IBOutlet UILabel *labe_outTitle;
    __weak IBOutlet UILabel *label_outDesc;
    __weak IBOutlet UITextField *pwdTxt;
    __weak IBOutlet UILabel *lable_pwd;
    __weak IBOutlet UILabel *lable_pwdDesc;
    __weak IBOutlet UIButton *btn_Out;
}
@end

@implementation memberOutViewController

- (IBAction)OutBtnClick:(id)sender {
    
    [btn_Out setEnabled:false ];
    
    NSString *strPassLenMsg = nil;
    NSString *strOutMsg = nil;

    
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        strPassLenMsg = NO_SAME_PWD_KO;
        strOutMsg = PERSON_MEMBER_OUT_KO;
    }else{
        strPassLenMsg = NO_SAME_PWD_VI;
         strOutMsg = PERSON_MEMBER_OUT_VI;
    }
    
    
    if([pwdTxt.text length] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:strPassLenMsg delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
        [alert show];
        [pwdTxt becomeFirstResponder];
        [btn_Out setEnabled:true ];

        return;
    }
    
    NSString *strPwd = [[NSUserDefaults standardUserDefaults] stringForKey:kPwd];
    if(![pwdTxt.text isEqualToString:strPwd]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:strPassLenMsg delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
        [alert show];
        [pwdTxt becomeFirstResponder];
        [btn_Out setEnabled:true ];
        
        return;
    }

    
    
    
    UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
    [likeImageView setCenter:CGPointMake(kScreenBoundsWidth/2, kScreenBoundsHeight/2)];
    [likeImageView setImage:[UIImage imageNamed:@"loding_cha_01@3x.png"]];
    [self.view addSubview:likeImageView];
    [self.view bringSubviewToFront:likeImageView];
    
    if ([SYSTEM_VERSION intValue] > 7) {
        likeImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:3.0f
                              delay:0
             usingSpringWithDamping:0.2f
              initialSpringVelocity:6.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             likeImageView.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             [likeImageView removeFromSuperview];
                         }];
    }
    else {
        [UIView animateWithDuration:1.0f animations:^{
            [likeImageView removeFromSuperview];
        }];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *rootDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *indiv_infoDic = [NSMutableDictionary dictionary];
    
    [rootDic setObject:@"" forKey:@"task"];
    [rootDic setObject:@"" forKey:@"action"];
    [rootDic setObject:@"A7700U" forKey:@"serviceCode"];
    [rootDic setObject:@"" forKey:@"requestMessage"];
    [rootDic setObject:@"" forKey:@"responseMessage"];
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:kCardCode]){
        [indiv_infoDic setObject:[[NSUserDefaults standardUserDefaults] stringForKey:kCardCode] forKey:@"user_seq"];
    }
    if([[NSUserDefaults standardUserDefaults] stringForKey:kId]){
        [indiv_infoDic setObject:[[NSUserDefaults standardUserDefaults] stringForKey:kEmail_id] forKey:@"email_id"];
    }
    
    [indiv_infoDic setObject:pwdTxt.text forKey:@"pinno"];
    
    [sendDic setObject:rootDic forKey:@"root_info"];
    [sendDic setObject:indiv_infoDic forKey:@"indiv_info"];//////
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonString = [jsonWriter stringWithObject:sendDic];
    NSLog(@"request json: %@", jsonString);
    
    NSDictionary *parameters = @{@"plainJSON": jsonString};
    
    [manager POST:API_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSString *responseData = (NSString*) responseObject;
        NSArray *jsonArray = (NSArray *)responseData;
        NSDictionary * dicResponse = (NSDictionary *)responseData;
        
        //warning
        NSDictionary *dicItems = [dicResponse objectForKey:@"WARNING"];
        
        if(dicItems){
            NSString* sError = dicItems[@"msg"];
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:sError delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [btn_Out setEnabled:true ];
            //[self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            
            //to json
            SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
            NSString *jsonString = [jsonWriter stringWithObject:jsonArray];
            NSLog(@"jsonString ==> %@", jsonString);
            
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
            NSHTTPCookie *cookie;
            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
            [cookieProperties setObject:@"locale_" forKey:NSHTTPCookieName];
            [cookieProperties setObject:@"KO" forKey:NSHTTPCookieValue];
            [cookieProperties setObject:@"vntst.shinhanglobal.com" forKey:NSHTTPCookieDomain];
            [cookieProperties setObject:@"vntst.shinhanglobal.com" forKey:NSHTTPCookieOriginURL];
            [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
            [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
            // set expiration to one month from now
            [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
            cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            
            for (cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
                NSLog(@"%@=%@", cookie.name, cookie.value);
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:strOutMsg delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            leftViewController *leftViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).gLeftViewController;
            [leftViewController setViewLogout];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            [btn_Out setEnabled:true ];
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Fail %@", error] delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
        [alert show];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [btn_Out setEnabled:true ];
        
    }];
    
    //
    //    if(myLoginType == LoginTypeConfig){
    //        [self.navigationController popViewControllerAnimated:YES];
    //        if ([self.delegate respondsToSelector:@selector(didLoginAfter)]) {
    //            [self.delegate didLoginAfter];
    //        }
    //
    //    }else{
    //        [self.navigationController popToRootViewControllerAnimated:YES];
    //    }
    
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

    
    [self resetNavigationBarView:1];
    [self setDelegateText];
    [pwdTxt setKeyboardType:UIKeyboardTypeNumberPad ];
    
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        [self initScreenView_ko];
    }else{
        [self initScreenView_vi];
    }
    
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
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-marginX, kScreenBoundsHeight-(kToolBarHeight+15), kScreenBoundsWidth, kToolBarHeight)];
        //[backgroundImageView setImage:[UIImage imageNamed:strImage]];
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill; //UIViewContentModeScaleAspectFit
        [self.view addSubview:backgroundImageView];
        
        NSURL *imageURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:kMainBannerImgUrl]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                backgroundImageView.image = [UIImage imageWithData:imageData];
                if([imageData length] < 1){
                    [backgroundImageView setImage:[UIImage imageNamed:strImage]];
                }
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
        //[backgroundImageView setImage:[UIImage imageNamed:strImage]];
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill; //UIViewContentModeScaleAspectFit
        [self.view addSubview:backgroundImageView];
        
        NSURL *imageURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:kMainBannerImgUrl]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                backgroundImageView.image = [UIImage imageWithData:imageData];
                if([imageData length] < 1){
                    [backgroundImageView setImage:[UIImage imageNamed:strImage]];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(didTouchMainAD)]) {
        [self.delegate didTouchMainAD];
    }
}

/////
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Navigation : viewDidLoad에서 한번, viewDidAppear에서 한번 더 한다.
    //[self.navigationItem setHidesBackButton:YES];
    [self resetNavigationBarView:1];
    
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -initScreenView
-(void)initScreenView_ko{
    
    [self resetNavigationBarView:1];
    [labe_outTitle setText:MEM_OUT_TITLE_KO];
    [label_outDesc setText:MEM_OUT_DESC_KO];
    [lable_pwd setText:MEM_PWD_TITLE_KO];
    [lable_pwdDesc setText:MEM_PWD_DESC_KO];
    [btn_Out setTitle:MEM_OUT_KO forState:UIControlStateNormal];
}

-(void)initScreenView_vi{
    
    [self resetNavigationBarView:1];
    [labe_outTitle setText:MEM_OUT_TITLE_VI];
    [label_outDesc setText:MEM_OUT_DESC_VI];
    [lable_pwd setText:MEM_PWD_TITLE_VI];
    [lable_pwdDesc setText:MEM_PWD_DESC_VI];
    [btn_Out setTitle:MEM_OUT_VI forState:UIControlStateNormal];
    
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - text delegate
// Automatically register fields
-(void)setDelegateText
{
    [pwdTxt setDelegate:self];
    
}
// UITextField Protocol
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentEditingTextField = textField;
}
-(void)dateSave:(id)sender
{
    self.navigationItem.rightBarButtonItem=nil;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    currentEditingTextField = NULL;
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self endEdit];
//}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endEdit];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self textFieldValueIsValid:textField]) {
        [self endEdit];
        return YES;
    } else {
        return NO;
    }
}
// Own functions
-(void)endEdit
{
    if (currentEditingTextField) {
        [currentEditingTextField endEditing:YES];
        currentEditingTextField = NULL;
    }
}
// Override this in your subclass to handle eventual values that may prevent validation.
-(BOOL)textFieldValueIsValid:(UITextField*)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    if (pwdTxt.text.length >= PWD_MAX_LENGTH && range.length == 0)
    {
        [self endEdit];
        return NO; // return NO to not change text
    }
//    else if(textField.text.length >= PWD_MAX_LENGTH && range.length == 0){
//        
//        return NO; // return NO to not change text
//    }
//    
    return YES;
    
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
        navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeight) type:navigationType title:PERSON_MEMBER_OUT_KO];
        [navigationBarView setDelegate:self];
    }else{
        navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeight) type:navigationType title:PERSON_MEMBER_OUT_VI];
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

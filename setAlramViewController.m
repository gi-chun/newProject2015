//
//  setAlramViewController.m
//  gcleeEmpty
//
//  Created by gclee on 2015. 11. 25..
//  Copyright © 2015년 gclee. All rights reserved.
//

#import "setAlramViewController.h"
#import "NavigationBarView.h"
#import "AFHTTPRequestOperationManager.h"
#import "SBJson.h"

@interface setAlramViewController ()
{
    __weak IBOutlet UILabel *labelTotalAlram;
    __weak IBOutlet UILabel *labelDesc;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *nomalLabel;
    __weak IBOutlet UILabel *contentsLabel;
    __weak IBOutlet UILabel *eventLabel;
    
    __weak IBOutlet UISwitch *switchTotal;
    __weak IBOutlet UIButton *nomalButton;
    __weak IBOutlet UIButton *contentsButton;
    __weak IBOutlet UIButton *eventButton;
    
     NavigationBarView *navigationBarView;
}
@end

@implementation setAlramViewController

- (IBAction)nomalButtonClick:(id)sender {
    
    BOOL isTuto = [[NSUserDefaults standardUserDefaults] boolForKey:kNomalPushY];
    if(isTuto == YES){
        //set no
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kNomalPushY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [nomalButton setImage:[UIImage imageNamed:@"check_box_btn.png"] forState:UIControlStateNormal];
        
        BOOL isAlram = [[NSUserDefaults standardUserDefaults] boolForKey:kContentsPushY];
        if(isAlram == NO){
            isAlram = [[NSUserDefaults standardUserDefaults] boolForKey:kEventPushY];
            if(isAlram == NO){
                [switchTotal setOn:false];
                [nomalButton setEnabled:false];
                [contentsButton setEnabled:false];
                [eventButton setEnabled:false];
            }
        }
        
        
    }else{
        //set yes
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNomalPushY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [nomalButton setImage:[UIImage imageNamed:@"check_box_btn_checked.png"] forState:UIControlStateNormal];
    }

}


- (IBAction)totalSwitchClick:(id)sender {

    if ( [switchTotal isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kPushY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNomalPushY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kContentsPushY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kEventPushY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [nomalButton setEnabled:true];
        [contentsButton setEnabled:true];
        [eventButton setEnabled:true];
        [nomalButton setImage:[UIImage imageNamed:@"check_box_btn_checked.png"] forState:UIControlStateNormal];
        [contentsButton setImage:[UIImage imageNamed:@"check_box_btn_checked.png"] forState:UIControlStateNormal];
        [eventButton setImage:[UIImage imageNamed:@"check_box_btn_checked.png"] forState:UIControlStateNormal];
        
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kPushY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kNomalPushY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kContentsPushY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kEventPushY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [nomalButton setEnabled:false];
        [contentsButton setEnabled:false];
        [eventButton setEnabled:false];
        [nomalButton setImage:[UIImage imageNamed:@"check_box_btn.png"] forState:UIControlStateNormal];
        [contentsButton setImage:[UIImage imageNamed:@"check_box_btn.png"] forState:UIControlStateNormal];
        [eventButton setImage:[UIImage imageNamed:@"check_box_btn.png"] forState:UIControlStateNormal];

    }

}

- (IBAction)contentsBtnClick:(id)sender {
    
    BOOL isTuto = [[NSUserDefaults standardUserDefaults] boolForKey:kContentsPushY];
    if(isTuto == YES){
        //set no
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kContentsPushY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [contentsButton setImage:[UIImage imageNamed:@"check_box_btn.png"] forState:UIControlStateNormal];
        
        BOOL isAlram = [[NSUserDefaults standardUserDefaults] boolForKey:kNomalPushY];
        if(isAlram == NO){
            isAlram = [[NSUserDefaults standardUserDefaults] boolForKey:kEventPushY];
            if(isAlram == NO){
                [switchTotal setOn:false];
                [nomalButton setEnabled:false];
                [contentsButton setEnabled:false];
                [eventButton setEnabled:false];
            }
        }
        
    }else{
        //set yes
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kContentsPushY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [contentsButton setImage:[UIImage imageNamed:@"check_box_btn_checked.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)eventBtnClick:(id)sender {
    
    BOOL isTuto = [[NSUserDefaults standardUserDefaults] boolForKey:kEventPushY];
    if(isTuto == YES){
        //set no
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kEventPushY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [eventButton setImage:[UIImage imageNamed:@"check_box_btn.png"] forState:UIControlStateNormal];
        
        BOOL isAlram = [[NSUserDefaults standardUserDefaults] boolForKey:kNomalPushY];
        if(isAlram == NO){
            isAlram = [[NSUserDefaults standardUserDefaults] boolForKey:kContentsPushY];
            if(isAlram == NO){
                [switchTotal setOn:false];
                [nomalButton setEnabled:false];
                [contentsButton setEnabled:false];
                [eventButton setEnabled:false];
            }
        }
        
    }else{
        //set yes
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kEventPushY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [eventButton setImage:[UIImage imageNamed:@"check_box_btn_checked.png"] forState:UIControlStateNormal];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [nomalLabel setNumberOfLines:0];
    
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
    
    [self getAlarmInfo];
    
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

- (void)touchToolbar:(id)sender
{
    //UIButton *button = (UIButton *)sender;
    if ([self.delegate respondsToSelector:@selector(didTouchMainAD)]) {
        [self.delegate didTouchMainAD];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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

- (void)getAlarmInfo
{
    CGFloat marginX = 0;
    if(kScreenBoundsWidth > 320){
        if(kScreenBoundsWidth > 400){
            marginX = -36;
        }else{
            marginX = -16;
        }
    }else{
        marginX = 8;
    }
    
    UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
    [likeImageView setCenter:CGPointMake(kScreenBoundsWidth/2+marginX, kScreenBoundsHeight/2)];
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
    
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *rootDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *indiv_infoDic = [NSMutableDictionary dictionary];
    
    //
    [rootDic setObject:@"sfg.sunny.task.user.AlarmTask" forKey:@"task"];
    [rootDic setObject:@"getAlarm" forKey:@"action"];
    [rootDic setObject:@"" forKey:@"serviceCode"];
    [rootDic setObject:@"" forKey:@"requestMessage"];
    [rootDic setObject:@"" forKey:@"responseMessage"];
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:kCardCode]){
        [indiv_infoDic setObject:[[NSUserDefaults standardUserDefaults] stringForKey:kCardCode] forKey:@"user_seq"];
    }
    
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
        NSLog(@"Response ==> %@", responseData);
        
        //warning
        NSDictionary *dicItems = [dicResponse objectForKey:@"WARNING"];
        
        if(dicItems){
            NSString* sError = dicItems[@"msg"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:sError delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else{
            
            dicItems = nil;
            dicItems = [dicResponse objectForKey:@"indiv_info"];
            NSString* sPushY = dicItems[@"push_rec_yn"];
            
            if([sPushY isEqualToString:@"Y"]){
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kPushY];
                [[NSUserDefaults standardUserDefaults] synchronize];

            }else{
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kPushY];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            NSString* sTotalSet = dicItems[@"push_alarm"];
            
            NSString *nomalSet;
            NSString *contentSet;
            NSString *eventSet;
            
            //1|Y,2|Y,3|Y
            NSRange range = {2,1};
            nomalSet = [sTotalSet substringWithRange:range];
            NSRange range_ = {6,1};
            contentSet = [sTotalSet substringWithRange:range_];
            NSRange range__ = {10,1};
            eventSet = [sTotalSet substringWithRange:range__];
            
            if([nomalSet isEqualToString:@"Y"]){
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNomalPushY];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }else{
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kNomalPushY];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }

            if([contentSet isEqualToString:@"Y"]){
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kContentsPushY];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }else{
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kContentsPushY];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }

            if([eventSet isEqualToString:@"Y"]){
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kEventPushY];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }else{
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kEventPushY];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            NSLog(@"Response ==> %@", responseData);
            
            //to json
            SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
            NSString *jsonString = [jsonWriter stringWithObject:jsonArray];
            NSLog(@"jsonString ==> %@", jsonString);
            //save login info
            [[NSUserDefaults standardUserDefaults] setObject:jsonString forKey:kLoginData];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
            NSHTTPCookie *cookie;
            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
            [cookieProperties setObject:@"locale_" forKey:NSHTTPCookieName];
            //        [cookieProperties setObject:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]] forKey:NSHTTPCookieValue];
            //////////////////////////////////////
            [cookieProperties setObject:@"KO" forKey:NSHTTPCookieValue];
            [cookieProperties setObject:COOKIE_SAVE_DOMAIN forKey:NSHTTPCookieDomain];
            [cookieProperties setObject:COOKIE_SAVE_DOMAIN forKey:NSHTTPCookieOriginURL];
            [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
            [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
            // set expiration to one month from now
            [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
            cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            
            for (cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
                NSLog(@"%@=%@", cookie.name, cookie.value);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
}

- (void)didTouchBackButton
{
    CGFloat marginX = 0;
    if(kScreenBoundsWidth > 320){
        if(kScreenBoundsWidth > 400){
            marginX = -36;
        }else{
            marginX = -16;
        }
    }else{
        marginX = 8;
    }
    
    UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
    [likeImageView setCenter:CGPointMake(kScreenBoundsWidth/2+marginX, kScreenBoundsHeight/2)];
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
    
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *rootDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *indiv_infoDic = [NSMutableDictionary dictionary];
    
    NSString *nomalSet;
    NSString *contentSet;
    NSString *eventSet;
    NSString *totalSet;
    NSString *BIGSet;
    
    BOOL isAlram = [[NSUserDefaults standardUserDefaults] boolForKey:kPushY];
    if(isAlram == YES){
        BIGSet = @"Y";
        
        BOOL isAlram = [[NSUserDefaults standardUserDefaults] boolForKey:kNomalPushY];
        if(isAlram == YES){
            nomalSet = @"Y";
        }else{
            nomalSet = @"N";
        }
        
        isAlram = [[NSUserDefaults standardUserDefaults] boolForKey:kContentsPushY];
        if(isAlram == YES){
            contentSet = @"Y";
        }else{
            contentSet = @"N";
        }
        
        isAlram = [[NSUserDefaults standardUserDefaults] boolForKey:kEventPushY];
        if(isAlram == YES){
            eventSet = @"Y";
        }else{
            eventSet = @"N";
        }
        
    }else{
         BIGSet = @"N";
        nomalSet = @"N";
        contentSet = @"N";
        eventSet = @"N";
    }
    
    totalSet = [NSString stringWithFormat:@"1|%@,2|%@,3|%@", nomalSet, contentSet, eventSet];
    //
    [rootDic setObject:@"sfg.sunny.task.user.AlarmTask" forKey:@"task"];
    [rootDic setObject:@"setAlarm" forKey:@"action"];
    [rootDic setObject:@"" forKey:@"serviceCode"];
    [rootDic setObject:@"" forKey:@"requestMessage"];
    [rootDic setObject:@"" forKey:@"responseMessage"];
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:kCardCode]){
        [indiv_infoDic setObject:[[NSUserDefaults standardUserDefaults] stringForKey:kCardCode] forKey:@"user_seq"];
    }
    
    [indiv_infoDic setObject:BIGSet forKey:@"push_rec_yn"];
    [indiv_infoDic setObject:totalSet forKey:@"push_alarm"];
    
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
        NSLog(@"Response ==> %@", responseData);
        
        //warning
        NSDictionary *dicItems = [dicResponse objectForKey:@"WARNING"];
        
        if(dicItems){
            NSString* sError = dicItems[@"msg"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:sError delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else{
            
            //to json
            SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
            
            NSString *jsonString = [jsonWriter stringWithObject:jsonArray];
            NSLog(@"jsonString ==> %@", jsonString);
            ///////////////////////////////
            
            for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
            {
                NSLog(@"name: '%@'\n",   [cookie name]);
                NSLog(@"value: '%@'\n",  [cookie value]);
                NSLog(@"domain: '%@'\n", [cookie domain]);
                NSLog(@"path: '%@'\n",   [cookie path]);
            }
            
            NSLog(@"getCookie end ==>" );
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
    
    
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
    [nomalLabel setText:SET_PUSH_NOMAL_KO];
    [contentsLabel setText:SET_PUSH_CONTENTS_KO];
    [eventLabel setText:SET_PUSH_EVENT_KO];
    
    BOOL isAlram = [[NSUserDefaults standardUserDefaults] boolForKey:kPushY];
    if(isAlram == YES){
        [switchTotal setOn:true];
        [nomalButton setEnabled:true];
        [contentsButton setEnabled:true];
        [eventButton setEnabled:true];
    }else{
        [switchTotal setOn:false];
        [nomalButton setEnabled:false];
        [contentsButton setEnabled:false];
        [eventButton setEnabled:false];
    }
    
    isAlram = [[NSUserDefaults standardUserDefaults] boolForKey:kNomalPushY];
    if(isAlram == YES){
        [nomalButton setImage:[UIImage imageNamed:@"check_box_btn_checked.png"] forState:UIControlStateNormal];
    }
    
    isAlram = [[NSUserDefaults standardUserDefaults] boolForKey:kContentsPushY];
    if(isAlram == YES){
        [contentsButton setImage:[UIImage imageNamed:@"check_box_btn_checked.png"] forState:UIControlStateNormal];
    }
    
    isAlram = [[NSUserDefaults standardUserDefaults] boolForKey:kEventPushY];
    if(isAlram == YES){
        [eventButton setImage:[UIImage imageNamed:@"check_box_btn_checked.png"] forState:UIControlStateNormal];
    }
}

-(void)initScreenView_vi{
    
    [self resetNavigationBarView:1];
    
    [labelTotalAlram setText:SET_PUSH_TOTAL_VI];
    [labelDesc setText:SET_PUSH_DESC_VI];
    [titleLabel setText:SET_PUSH_SET_TITLE_VI];
    [nomalLabel setText:SET_PUSH_NOMAL_VI];
    [contentsLabel setText:SET_PUSH_CONTENTS_VI];
    [eventLabel setText:SET_PUSH_EVENT_VI];
    
    BOOL isAlram = [[NSUserDefaults standardUserDefaults] boolForKey:kPushY];
    if(isAlram == YES){
        [switchTotal setOn:true];
        [nomalButton setEnabled:true];
        [contentsButton setEnabled:true];
        [eventButton setEnabled:true];
    }else{
        [switchTotal setOn:false];
        [nomalButton setEnabled:false];
        [contentsButton setEnabled:false];
        [eventButton setEnabled:false];
    }
    
    isAlram = [[NSUserDefaults standardUserDefaults] boolForKey:kNomalPushY];
    if(isAlram == YES){
        [nomalButton setImage:[UIImage imageNamed:@"check_box_btn_checked.png"] forState:UIControlStateNormal];
    }
    
    isAlram = [[NSUserDefaults standardUserDefaults] boolForKey:kContentsPushY];
    if(isAlram == YES){
        [contentsButton setImage:[UIImage imageNamed:@"check_box_btn_checked.png"] forState:UIControlStateNormal];
    }
    
    isAlram = [[NSUserDefaults standardUserDefaults] boolForKey:kEventPushY];
    if(isAlram == YES){
        [eventButton setImage:[UIImage imageNamed:@"check_box_btn_checked.png"] forState:UIControlStateNormal];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

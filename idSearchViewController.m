//
//  idSearchViewController.m
//  gcleeEmpty
//
//  Created by gclee on 2015. 11. 21..
//  Copyright © 2015년 gclee. All rights reserved.
//

#import "idSearchViewController.h"

#import "AFHTTPRequestOperationManager.h"
#import "SBJson.h"
#import "NavigationBarView.h"
#import "datePickerViewController.h"
#import "idResultViewController.h"

@interface idSearchViewController () <NavigationBarViewDelegate>
{
    
    
    NavigationBarView *navigationBarView;
    NSString *strYYYY;
    NSString *strInitYYY;
   
    UITextField* currentEditingTextField;
     __weak IBOutlet UITextField *idTxt;
    __weak IBOutlet UILabel *yyyyLabel;
    __weak IBOutlet UILabel *label_name;
    __weak IBOutlet UILabel *label_yyyy;
    __weak IBOutlet UIButton *btnSearh;
    __weak IBOutlet UILabel *labelComment;
}
@end

@implementation idSearchViewController

- (void)didTouchPicker{
    
//    [[NSUserDefaults standardUserDefaults] setObject:dicItems[@"email"] forKey:kYYYYMMDD];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    UITextField* currentEditingTextField;
   
    strYYYY = [[NSUserDefaults standardUserDefaults] stringForKey:kYYYYMMDD];
    [yyyyLabel setText:[self returnYYYYValuePerLan:strYYYY]];

}

- (NSString*)returnYYYYValuePerLan:(NSString*)pParam{
    
    NSString *result = nil;
    NSString* yyyy;
    NSString* mm;
    NSString* dd;
    
    NSRange range = {0,4};
    yyyy = [pParam substringWithRange:range];
    NSRange range_ = {4,2};
    mm = [pParam substringWithRange:range_];
    NSRange range__ = {6,2};
    dd = [pParam substringWithRange:range__];
    
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    
    if([temp isEqualToString:@"ko"]){
        result = [NSString stringWithFormat:@"%@년 %@월 %@일", yyyy, mm, dd];
    }else{
        result = [NSString stringWithFormat:@"%@day %@month %@year", dd, mm, yyyy];
    }
    
    return result;
}

- (IBAction)dayButtonClick:(id)sender {
    
    datePickerViewController *myPickerController = [[datePickerViewController alloc] init];
    [myPickerController setDelegate:self];
    
    //[myPickerController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:myPickerController animated:YES completion:nil];
}

- (IBAction)saveBtnClick:(id)sender {
    
    [btnSearh setEnabled:false];
    
    if([idTxt.text length] == 0){
        
        NSString* temp;
        temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
        if([temp isEqualToString:@"ko"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NAME_CHECK_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NAME_CHECK_VI delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
        }
        [idTxt becomeFirstResponder];
        
        [btnSearh setEnabled:true];
        return;
    }
    
    if([yyyyLabel.text isEqualToString:strInitYYY]){
        
        NSString* temp;
        temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
        if([temp isEqualToString:@"ko"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:BIRTH_CHECK_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:BIRTH_CHECK_VI delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
        }
        [idTxt becomeFirstResponder];
        [btnSearh setEnabled:true];
        return;
    }
    
    if([yyyyLabel.text length] == 0){
        
        NSString* temp;
        temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
        if([temp isEqualToString:@"ko"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:BIRTH_CHECK_KO delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:BIRTH_CHECK_VI delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
            [alert show];
        }
        [idTxt becomeFirstResponder];
        [btnSearh setEnabled:true];
        return;
    }

    
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
    
    [rootDic setObject:TASK_USR forKey:@"task"];
    [rootDic setObject:@"searchEmail" forKey:@"action"];
    [rootDic setObject:@"" forKey:@"serviceCode"];
    [rootDic setObject:@"" forKey:@"requestMessage"];
    [rootDic setObject:@"" forKey:@"responseMessage"];
    
    [indiv_infoDic setObject:strYYYY forKey:@"birth"];
    [indiv_infoDic setObject:idTxt.text forKey:@"user_nm"];
    
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
            
            //[self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            
//            dicItems = [dicResponse objectForKey:@"root_info"];
//            NSString* sCount = dicItems[@"result"];
//            
//            if([sCount isEqualToString:@"0"]){
//                [btnSearh setEnabled:true];
//                
//                NSString* temp;
//                temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
//                if([temp isEqualToString:@"ko"]){
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NOT_EXIT_ID_KO delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//                    [alert show];
//                }else{
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NOT_EXIT_ID_VI delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//                    [alert show];
//                }
//                
//                [idTxt becomeFirstResponder];
//                
//                return;
//            }
            
            NSArray *sEmailArray = [dicResponse objectForKey:@"indiv_info"];
            NSString* sEmail = @"";
            NSString* strTemp = @"";
            NSString* strFullEmail = @"";
            NSString* strHeadEmail = @"";
            NSString* strTailEmail = @"";
           
            NSMutableString *sEmailM = [[NSMutableString alloc] init];
            
            for (NSDictionary *sEmailItem in sEmailArray) {
                
                strFullEmail = sEmailItem[@"email_id"];
                NSRange range = [strFullEmail rangeOfString:@"@"];
                if (range.location != NSNotFound)
                {
                    strHeadEmail = [strFullEmail substringToIndex:range.location];
                    strTailEmail = [strFullEmail substringFromIndex:range.location];
                    
                    if([strHeadEmail length] > 2){
                        for (int i = 0; i < strHeadEmail.length; i++) {
                            
                            if(i != 0 && i != (strHeadEmail.length -1)){
                                
                                NSRange rangeSub = NSMakeRange(i, 1);
                                strHeadEmail = [strHeadEmail stringByReplacingCharactersInRange:rangeSub withString:@"*"];
                            }
                        }
                        strFullEmail = [NSString stringWithFormat:@"%@%@", strHeadEmail, strTailEmail];
                    }
                    [sEmailM appendFormat:@"%@\n",strFullEmail];
                }
            }
            sEmail = sEmailM;
            
            //to json
            SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
            NSString *jsonString = [jsonWriter stringWithObject:jsonArray];
            NSLog(@"jsonString ==> %@", jsonString);
            
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
            NSHTTPCookie *cookie;
            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
            [cookieProperties setObject:@"locale_" forKey:NSHTTPCookieName];
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
            
//            NSString * stSearch = [NSString stringWithFormat:@"조회된 아이디는 [%@] 입니다. ", sEmail];
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:stSearch delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//            [alert show];
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            idResultViewController *idResultController = [[idResultViewController alloc] init];
            [idResultController setDelegate:self];
            [idResultController setId:sEmail];
            [self.navigationController pushViewController:idResultController animated:YES];
            
            //[self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        
        [btnSearh setEnabled:true];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
//        NSString* temp;
//        temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
//        if([temp isEqualToString:@"ko"]){
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Fail %@", error] delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
//            [alert show];
//            
//        }else{
//            
//        }
        
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [btnSearh setEnabled:true];
        
    }];

    
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
    
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        [self initScreenView_ko];
    }else if([temp isEqualToString:@"vi"]){
        [self initScreenView_vi];
    }else{
        temp = @"EN";
    }
    
    idTxt.text = [[NSUserDefaults standardUserDefaults] stringForKey:kUserNm] ;
    //[idTxt becomeFirstResponder];
    
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
    if ([self.delegate respondsToSelector:@selector(didTouchMainAD)]) {
        [self.delegate didTouchMainAD];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)didTouchMainAD{
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - text delegate
// Automatically register fields
-(void)setDelegateText
{
    [idTxt setDelegate:self];
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
    }else if([temp isEqualToString:@"vi"]){
        navigationBarView = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundsWidth, kNavigationHeight) type:navigationType title:IDSEARCH_TITLE_VI];
        [navigationBarView setDelegate:self];
    }else{
        temp = @"EN";
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
    
    strInitYYY = @" 년 월 일";
    [yyyyLabel setText:strInitYYY];
    [self resetNavigationBarView:1];
    [label_name setText:IDSEARCH_NAME_KO];
    [labelComment setText:CLASSIFY_CAPITAL_KO];
    [label_yyyy setText:IDSEARCH_YYYY_KO];
    [btnSearh setTitle:IDSEARCH_SEARCH_KO forState:UIControlStateNormal];
    
}

-(void)initScreenView_vi{
    
    strInitYYY = @" day month year";
    [yyyyLabel setText:strInitYYY];
    [self resetNavigationBarView:1];
    [label_name setText:IDSEARCH_NAME_VI];
    [labelComment setText:CLASSIFY_CAPITAL_VI];
    [label_yyyy setText:IDSEARCH_YYYY_VI];
    [btnSearh setTitle:IDSEARCH_SEARCH_VI forState:UIControlStateNormal];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end

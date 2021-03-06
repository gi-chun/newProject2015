//
//  myPickerViewController.m
//  gcleeEmpty
//
//  Created by gclee on 2015. 11. 22..
//  Copyright © 2015년 gclee. All rights reserved.
//

#import "myPickerViewController.h"

@interface myPickerViewController ()
{
    
    __weak IBOutlet UIPickerView *myPicker;
    __weak IBOutlet UILabel *langLabel;
    NSArray *pickerData;
    __weak IBOutlet UIButton *btnSave;
}
@end

@implementation myPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    if(kScreenBoundsWidth > 320){
        if(kScreenBoundsWidth > 400){
            [self.view setBounds:CGRectMake(-kPopWindowMarginW*2, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        }else{
            [self.view setBounds:CGRectMake(-kPopWindowMarginW, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        }
    }
    
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        
        [btnSave setTitle:SAVE_KO forState:UIControlStateNormal];
    }else{
        [btnSave setTitle:SAVE_VI forState:UIControlStateNormal];
    }
    
//    [self.view setBounds:CGRectMake(-kPopWindowMarginW, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    //set data
    // Initialize Data
    pickerData = @[@"VIETNAMESE", @"KOREA"];
    
    myPicker.dataSource = self;
    myPicker.delegate = self;
    
     if([temp isEqualToString:@"ko"]){
         [myPicker selectRow:1 inComponent:0 animated:YES];
     }else{
         [myPicker selectRow:0 inComponent:0 animated:YES];
     }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    [langLabel setText:pickerData[row]];
    
    //    userDefaults = [NSUserDefaults standardUserDefaults];
    //    languages = [userDefaults objectForKey:@"AppleLanguages"];
    //    localLang = languages[0];
    NSString* localLang = (row == 0)?@"vi":@"ko";
    [[NSUserDefaults standardUserDefaults] setObject:localLang forKey:klang];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    return pickerData[row];
}


- (IBAction)okClick:(id)sender {
    
//    //set language
//    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//    NSMutableArray* languages = [userDefaults objectForKey:@"AppleLanguages"];
//        NSString* localLang = languages[0];
//    
//        [[NSUserDefaults standardUserDefaults] setObject:localLang forKey:klang];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    // set language
////    [languages insertObject:@"vi" atIndex:0]; // ISO639-1
////    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    if([localLang isEqualToString:@"ko"]){
//        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"vi", @"ko", @"en", nil] forKey:@"AppleLanguages"];
//        [[NSUserDefaults standardUserDefaults] synchronize]; //to make the change immediate
//    }else{
//        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"ko", @"vi", @"en", nil] forKey:@"AppleLanguages"];
//        [[NSUserDefaults standardUserDefaults] synchronize]; //to make the change immediate
//        
//    }
//    
//    userDefaults = [NSUserDefaults standardUserDefaults];
//    languages = [userDefaults objectForKey:@"AppleLanguages"];
//    localLang = languages[0];
    
//    [[NSUserDefaults standardUserDefaults] setObject:localLang forKey:klang];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([self.delegate respondsToSelector:@selector(didTouchPicker)]) {
        [self.delegate didTouchPicker];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

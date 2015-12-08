//
//  datePickerViewController.m
//  gcleeEmpty
//
//  Created by gclee on 2015. 11. 22..
//  Copyright © 2015년 gclee. All rights reserved.
//

#import "datePickerViewController.h"


@interface datePickerViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPickerMe;
@property (weak, nonatomic) IBOutlet UILabel *dayLable;

@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@end

@implementation datePickerViewController

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
    
    UIDatePicker *picker = _dataPickerMe;
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateStyle = NSDateFormatterMediumStyle;
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSString *date = [dateFormat stringFromDate:picker.date];
    NSLog(@"date is >>> , %@",date);
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@",[df stringFromDate:picker.date]]);
    
    [_dayLable setText:date];
    
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:kYYYYMMDD];
    
    
    NSString* temp;
    temp = [[NSUserDefaults standardUserDefaults] stringForKey:klang];
    if([temp isEqualToString:@"ko"]){
        
        [_btnSave setTitle:SAVE_KO forState:UIControlStateNormal];
    }else{
        [_btnSave setTitle:SAVE_VI forState:UIControlStateNormal];
    }
    
    [_dataPickerMe addTarget:self
               action:@selector(datePickerValueChanged:)
     forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Navigation : viewDidLoad에서 한번, viewDidAppear에서 한번 더 한다.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)okClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didTouchPicker)]) {
        [self.delegate didTouchPicker];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)datePickerValueChanged:(id)sender{
    
    UIDatePicker *picker = (UIDatePicker *)sender;
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateStyle = NSDateFormatterMediumStyle;
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSString *date = [dateFormat stringFromDate:picker.date];
    NSLog(@"date is >>> , %@",date);
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@",[df stringFromDate:picker.date]]);
    
    NSString* strDate = nil;
    strDate = [self returnYYYYValuePerLan:date];
    
    [_dayLable setText:strDate];
    
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:kYYYYMMDD];
    
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

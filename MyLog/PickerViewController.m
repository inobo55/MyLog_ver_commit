//
//  PickerViewController.m
//  MyLog
//
//  Created by inoue on 2013/11/03.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController ()

@end

@implementation PickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closePickerView:(id)sender {
    // PickerViewを閉じるための処理を呼び出す
    [self.delegate closePickerView:self];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    [self.delegate applySelectedString:[LogConfiguration getQtextOfConfig:row]
                             log_index:self.log_index qa_index:self.qa_index];
    
}

#pragma pickerView

// PickerViewの列数を指定するメソッド
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView {
    return 1;
}

// PickerViewに表示する行数を指定するメソッド
-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[LogConfiguration getLogConfig] count];
}

// PickerViewの各行に表示する文字列を指定するメソッド
-(NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [LogConfiguration getQtextOfConfig:row];
}


@end

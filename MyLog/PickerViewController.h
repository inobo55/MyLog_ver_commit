//
//  PickerViewController.h
//  MyLog
//
//  Created by inoue on 2013/11/03.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogConfiguration.h"

@protocol PickerViewControllerDelegate;

@interface PickerViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *closeButton;

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak,nonatomic)id<PickerViewControllerDelegate>delegate;

@property (nonatomic)NSUInteger log_index;

@property (nonatomic)NSUInteger qa_index;

- (IBAction)closePickerView:(id)sender;

@end


@protocol PickerViewControllerDelegate <NSObject>

// 選択された文字列を適用するためのデリゲートメソッド
-(void)applySelectedString:(NSString *)Qtext log_index:(NSUInteger)log_index qa_index:(NSUInteger)qa_index;
// 当該PickerViewを閉じるためのデリゲートメソッド
-(void)closePickerView:(PickerViewController *)controller;

@end
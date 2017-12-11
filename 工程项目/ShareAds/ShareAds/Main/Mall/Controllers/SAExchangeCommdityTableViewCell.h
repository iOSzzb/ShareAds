//
//  SAExchangeCommdityTableViewCell.h
//  ShareAds
//
//  Created by 张振波 on 2017/12/11.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,SAExTBCellTextFieldStatus) {
    SAExTBCellTextFieldStatusBegin,
    SAExTBCellTextFieldStatusEnd
};
@interface SAExchangeCommdityTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, copy) void(^textFieldCallbackBlock)(UITextField *textView,SAExTBCellTextFieldStatus status);
@end

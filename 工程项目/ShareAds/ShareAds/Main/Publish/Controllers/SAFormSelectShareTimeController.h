//
//  PBChangeSexViewController.h
//  PartyBuilding
//
//  Created by 张振波 on 2017/7/19.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "BaseViewController.h"
@class SAFormSelectShareTimeController;
@protocol SAFormSelectShareTimeControllerDelegate <NSObject>
@optional
- (void)selectShareTimeController:(SAFormSelectShareTimeController *)vc didSelectTime:(NSString *)time;
@end
@interface SAFormSelectShareTimeController : BaseViewController
@property (nonatomic, weak) id<SAFormSelectShareTimeControllerDelegate>delegate;
@end

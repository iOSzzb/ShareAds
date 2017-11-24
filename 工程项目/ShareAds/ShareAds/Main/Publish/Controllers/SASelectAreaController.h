//
//  PBChangeSexViewController.h
//  PartyBuilding
//
//  Created by 张振波 on 2017/7/19.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "BaseViewController.h"
#import "Province.h"
#import "City.h"
#import "District.h"
@class SASelectAreaController;
@protocol SASelectAreaControllerDelegate <NSObject>
@optional
- (void)selectAreaController:(SASelectAreaController *)sexvc didSelectProvince:(Province *)province city:(City *)city district:(District *)district;
@end
@interface SASelectAreaController : BaseViewController
@property (nonatomic, weak) id<SASelectAreaControllerDelegate>delegate;
@end

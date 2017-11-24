//
//  PBChangeSexViewController.h
//  PartyBuilding
//
//  Created by 张振波 on 2017/7/19.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "BaseViewController.h"
#import "Trade.h"

@class SASelectTradeViewController;
@protocol SASelectTradeViewControllerDelegate <NSObject>
@optional
- (void)selectTradeViewController:(SASelectTradeViewController *)vc didSelectTrade:(Trade *)trade;
@end
@interface SASelectTradeViewController : BaseViewController
@property (nonatomic, weak) id<SASelectTradeViewControllerDelegate>delegate;
@end

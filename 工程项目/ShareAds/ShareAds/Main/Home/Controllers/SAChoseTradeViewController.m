//
//  SAChoseTradeViewController.m
//  ShareAds
//
//  Created by 张振波 on 2017/12/5.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAChoseTradeViewController.h"
#import <Realm/Realm.h>
#import "MyFavoriteTrade.h"
#import "SAChoseTradeCollectionViewCell.h"
#import "SAChoseTradeHeader.h"
@interface SAChoseTradeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *colseBtn;
@property (nonatomic, strong) RLMArray<Trade> *myTrades;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, strong) RLMResults *allTrade;
@property (nonatomic, strong) RLMNotificationToken *refreshToken;
@end
static NSString * const kCellId = @"CellId";
static NSString * const kHeaderId = @"HeaderId";
@implementation SAChoseTradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    MyFavoriteTrade *myFavorite = [MyFavoriteTrade objectsWhere:@"userId = %@",[SAUser shareUser].userId].firstObject;
    self.myTrades = myFavorite.trades;
    NSMutableArray *ids = [NSMutableArray new];
    for (int i = 0; i < self.myTrades.count; i ++ ) {
        Trade *trade = [self.myTrades objectAtIndex:i];
        NSString *tradeId = trade.id;
        [ids addObject:tradeId];
    }
    self.allTrade = [[Trade allObjects] objectsWhere:@"!(id IN %@)",ids];
    __weak typeof(self) weakSelf = self;
    self.refreshToken = [self.myTrades addNotificationBlock:^(RLMArray * _Nullable array, RLMCollectionChange * _Nullable changes, NSError * _Nullable error) {
        NSMutableArray *innerids = [NSMutableArray new];
        for (int i = 0; i < array.count; i ++ ) {
            Trade *trade = [array objectAtIndex:i];
            NSString *tradeId = trade.id;
            [innerids addObject:tradeId];
        }
        weakSelf.allTrade = [[Trade allObjects] objectsWhere:@"!(id IN %@)",innerids];
        [weakSelf.collectionView reloadData];
    }];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SAChoseTradeCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCellId];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SAChoseTradeHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderId];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] init];
    [longPress addTarget:self action:@selector(longpress:)];
    [self.collectionView addGestureRecognizer:longPress];
    
}
//- (void)refreshData {
//    MyFavoriteTrade *myFavorite = [MyFavoriteTrade allObjects].firstObject;
//    self.myTrades = myFavorite.trades;
//    NSMutableArray *ids = [NSMutableArray new];
//    for (int i = 0; i < self.myTrades.count; i ++ ) {
//        Trade *trade = [self.myTrades objectAtIndex:i];
//        NSString *tradeId = trade.id;
//        [ids addObject:tradeId];
//    }
//    self.allTrade = [[Trade allObjects] objectsWhere:@"!(id IN %@)",ids];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeBtnOnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [self.myTrades removeObjectAtIndex:indexPath.row];
        [realm commitWriteTransaction];
    } else {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [self.myTrades addObject: [self.allTrade objectAtIndex:indexPath.row] ];
        [realm commitWriteTransaction];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.myTrades.count;
    } else {
        return self.allTrade.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SAChoseTradeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    if (indexPath.section == 0) {
        Trade *trade = self.myTrades[indexPath.item];
        cell.nameLabel.text = trade.desc;
    } else {
        Trade *trade = [self.allTrade objectAtIndex:indexPath.item];
        cell.nameLabel.text = trade.desc;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    SAChoseTradeHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderId forIndexPath:indexPath];
    if (indexPath.section == 0) {
        header.bigLabel.text = @"我的分类";
        header.littleLabel.text = @"长按拖动排序";
    } else {
        header.bigLabel.text = @"分类推荐";
        header.littleLabel.text = @"点击添加分类";

    }
    return header;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    if (sourceIndexPath.section == 0 && destinationIndexPath.section == 0) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        if (sourceIndexPath.item > destinationIndexPath.item) {
            for (NSUInteger i = sourceIndexPath.item; i > destinationIndexPath.item; i --) {
                [self.myTrades exchangeObjectAtIndex:i withObjectAtIndex:i-1];
            }
        } else {
            for (NSUInteger i = sourceIndexPath.item; i < destinationIndexPath.item; i ++) {
                [self.myTrades exchangeObjectAtIndex:i withObjectAtIndex:i+1];
            }
        }
        
//        [self.myTrades removeObjectAtIndex:sourceIndexPath.item];
        [realm commitWriteTransaction];
//        [self refreshData];
//        [self.collectionView reloadData];
    } else {//因为禁止了section 1的canMoveItemAtIndexPath，所以sourceIndexPath.section不可能为1
        [collectionView cancelInteractiveMovement];
    }
}

- (void)longpress:(UILongPressGestureRecognizer *)longpress {
    switch (longpress.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *selectedIndexpath = [self.collectionView indexPathForItemAtPoint:[longpress locationInView:self.collectionView]];
            if (selectedIndexpath) {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectedIndexpath];
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {
            [self.collectionView updateInteractiveMovementTargetPosition:[longpress locationInView:self.collectionView]];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            NSIndexPath *destinationIndexPath = [self.collectionView indexPathForItemAtPoint:[longpress locationInView:self.collectionView]];
            if (destinationIndexPath.section == 1) {
                [self.collectionView cancelInteractiveMovement];
            } else {
                [self.collectionView endInteractiveMovement];
            }
        }
            break;
        default: [self.collectionView cancelInteractiveMovement];
            break;
    }
}
@end

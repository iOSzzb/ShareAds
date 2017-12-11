//
//  SADropList.m
//  ShareAds
//
//  Created by 张振波 on 2017/12/10.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SADropList.h"
#import <Realm/Realm.h>
#import "CommodityType.h"
@interface SADropList()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RLMResults *commodities;
@property (nonatomic, strong) NSArray *sort;
@end
@implementation SADropList
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellId"];
        _commodities = [CommodityType allObjects];
        _tableView.rowHeight = 45;
        self.sort = @[@"01",@"02",@"03"];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self addSubview:_tableView];
        UITapGestureRecognizer *tapToDismiss = [[UITapGestureRecognizer alloc] init];
        [tapToDismiss addTarget:self action:@selector(dismiss)];
        tapToDismiss.delegate = self;
        [self addGestureRecognizer:tapToDismiss];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.sourceType) {
        case SADropListSourceTypeCommidy:
            return _commodities.count + 1;
            break;
        case SADropListSourceTypeSort:
            return _sort.count;
            break;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"CellId" forIndexPath:indexPath];
    switch (self.sourceType) {
        case SADropListSourceTypeCommidy: {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"全部分类";
            } else {
                CommodityType *commoditype = [_commodities objectAtIndex:indexPath.row - 1];
                cell.textLabel.text = commoditype.desc;
            }
            break;
        }
        case SADropListSourceTypeSort: {
            NSString *type = _sort[indexPath.row];
            if ([type isEqualToString:@"01"]) {
                cell.textLabel.text = @"人气";
            }
            if ([type isEqualToString:@"02"]) {
                cell.textLabel.text = @"时间";
            }
            if ([type isEqualToString:@"03"]) {
                cell.textLabel.text = @"价格";
            }
            break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(dropList:didSelectAtIndex:result:)]) {
        NSString *result = @"";
        switch (self.sourceType) {
            case SADropListSourceTypeCommidy: {
                if (indexPath.row == 0) {
                    result = @"";
                } else {
                    CommodityType *commoditype = [_commodities objectAtIndex:indexPath.row - 1];
                    result = commoditype.id;
                }
                break;
            }
            case SADropListSourceTypeSort: {
                NSString *type = _sort[indexPath.row];
                result = type;
                break;
            }
        }
        [self.delegate dropList:self didSelectAtIndex:indexPath.row result:result];
    }
}

- (void)setSourceType:(SADropListSource)sourceType {
    _sourceType = sourceType;
    [_tableView reloadData];
    [self setNeedsLayout];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger count = 0;
    switch (self.sourceType) {
        case SADropListSourceTypeCommidy:
            count = _commodities.count;
            break;
        case SADropListSourceTypeSort:
            count = _sort.count;
            break;
    }
    
    _tableView.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat height = 0;
        if (count > 6) {
            height = 45 * 6;
        } else {
            height = 45 * count;
        }
        _tableView.frame = CGRectMake(0, 0, self.bounds.size.width, height);
    }];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint locationInTableView = [gestureRecognizer locationInView:_tableView];
    if (locationInTableView.x > 0 && locationInTableView.y > 0 && locationInTableView.x < _tableView.bounds.size.width && locationInTableView.y < _tableView.bounds.size.height) {
        return NO;
    }
    return YES;
}
- (void)dismiss {
    [self removeFromSuperview];
}
@end

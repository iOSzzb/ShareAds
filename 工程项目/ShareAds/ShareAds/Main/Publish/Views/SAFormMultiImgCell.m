//
//  SAFormMultiImgCell.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/26.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAFormMultiImgCell.h"
#import "SAFormMutiImgCollectionCell.h"
#import "TZImagePickerController.h"
#import "AppDelegate.h"
@interface SAFormMultiImgCell ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate>
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIWindow *pickerWindow;
@end
static NSString * const kCollectionViewCellId = @"kCollectionViewCellId";
@implementation SAFormMultiImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionViewLayout = [UICollectionViewFlowLayout new];
    _collectionViewLayout.itemSize = CGSizeZero;
    _collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionViewLayout];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SAFormMutiImgCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:kCollectionViewCellId];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = LIGHT_GRAY_BACKGROUND_COLOR;
    [self.contentView addSubview:_collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self calculateCollectionViewFram];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SAFormViewModel *)model {
    [super setModel:model];
    _titleLabel.text = model.title;
    [_collectionView reloadData];
}
- (void)calculateCollectionViewFram {
    CGFloat collectionViewHeight = self.contentView.bounds.size.height - 16;
    _collectionViewLayout.itemSize = CGSizeMake(collectionViewHeight, collectionViewHeight);
    if (self.model.selectedImgs.count == 0) {
        //leadeing = self.contentView.bounds.size.width - CGRectGetMaxX(_titleLabel.frame) - (self.contentView.bounds.size.width - CGRectGetMaxX(_collectionView.frame)) - collectionViewHeight;
        _collectionView.frame = CGRectMake(self.contentView.bounds.size.width - collectionViewHeight - 8, 8, collectionViewHeight, collectionViewHeight);
    }
    else {
        _collectionView.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame) + 8, 8,self.contentView.bounds.size.width - CGRectGetMaxX(_titleLabel.frame) - collectionViewHeight - 8 - 8,collectionViewHeight);
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [self calculateCollectionViewFram];
    return self.model.selectedImgs.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SAFormMutiImgCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellId forIndexPath:indexPath];
    if (indexPath.row == self.model.selectedImgs.count) {
        cell.imgView.image = [UIImage imageNamed:@"publish_addNewPhoto"];
    }
    else {
        cell.imgView.image = self.model.selectedImgs[indexPath.item];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.model.selectedImgs.count) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9-self.model.selectedImgs.count delegate:self];
        imagePickerVc.photoWidth = 300;
        imagePickerVc.allowPickingOriginalPhoto = NO;
        imagePickerVc.autoDismiss = NO;
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        UIWindow *imgePickerWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, screenBounds.size.height, screenBounds.size.width, screenBounds.size.height)];
       // UIViewController *controller = [UIViewController new];
        imgePickerWindow.rootViewController = imagePickerVc;
        [imgePickerWindow makeKeyAndVisible];
        if([[NSOperationQueue currentQueue] isEqual:[NSOperationQueue mainQueue]]) {
            [UIView animateWithDuration:0.3 animations:^{
                imgePickerWindow.frame = screenBounds;
            } completion:^(BOOL finished) {
            }];
        }
        self.pickerWindow = imgePickerWindow;
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    if (isSelectOriginalPhoto) {
        
    }
    else {
        /*[self.pictures addObjectsFromArray:photos];
        for (int i = 0; i < photos.count; i++) {
            [self.uploadProcessArray addObject:@1.0];
            [self.fileIds addObject:@""];
        }
        [self.imageCollectionView reloadData];
         */
        if (self.model.selectedImgs == nil) {
            self.model.selectedImgs = photos;
        }
        else {
            NSMutableArray *mut = [NSMutableArray arrayWithArray:self.model.selectedImgs];
            [mut addObjectsFromArray:photos];
            self.model.selectedImgs = [mut copy];
        }
        [self.collectionView reloadData];
        
    }
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    if([[NSOperationQueue currentQueue] isEqual:[NSOperationQueue mainQueue]]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.pickerWindow.frame = CGRectMake(0, screenBounds.size.height, screenBounds.size.width, screenBounds.size.height);
        } completion:^(BOOL finished) {
            AppDelegate *appDeleage = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDeleage.window makeKeyAndVisible];
            self.pickerWindow = nil;
        }];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                self.pickerWindow.frame = CGRectMake(0, screenBounds.size.height, screenBounds.size.width, screenBounds.size.height);
            } completion:^(BOOL finished) {
                AppDelegate *appDeleage = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appDeleage.window makeKeyAndVisible];
                self.pickerWindow = nil;
            }];
        });
    }
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    NSLog(@"");
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    if([[NSOperationQueue currentQueue] isEqual:[NSOperationQueue mainQueue]]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.pickerWindow.frame = CGRectMake(0, screenBounds.size.height, screenBounds.size.width, screenBounds.size.height);
        } completion:^(BOOL finished) {
            AppDelegate *appDeleage = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDeleage.window makeKeyAndVisible];
            self.pickerWindow = nil;
        }];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.pickerWindow.frame = CGRectMake(0, screenBounds.size.height, screenBounds.size.width, screenBounds.size.height);
            } completion:^(BOOL finished) {
                AppDelegate *appDeleage = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appDeleage.window makeKeyAndVisible];
                self.pickerWindow = nil;
            }];
        });
    }
}

@end

//
//  SAFormViewController.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/25.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SAFormViewController.h"
#import "SAFormJumpSelectCell.h"
#import "SAFormInputCell.h"
#import "SAFormSwitchCell.h"
#import "SAFormViewModel.h"
#import "SAFromChoseImageCell.h"
#import "SAFormTextViewCell.h"
#import "SAFormMultiImgCell.h"
#import "SASelectTradeViewController.h"
#import "SASelectAreaController.h"
#import "SAFormMultiSelectCell.h"
#import "TZImagePickerController.h"
#import "SAFormSelectShareTimeController.h"
#import "SAFormShareChannelCell.h"
#import "SAUploadImgeStatusModel.h"
#import "CommonWebViewController.h"
#import "SAFormSwitchAndJumpCell.h"
@interface SAFormViewController ()<UITableViewDelegate,UITableViewDataSource,SASelectTradeViewControllerDelegate,SASelectAreaControllerDelegate,SAFormSelectShareTimeControllerDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) SAFormViewModel *hasUrlCell;
@property (nonatomic, strong) SAFormViewModel *adsIconCellModel;
@property (nonatomic, strong) UIResponder *firstResponder;
@property (nonatomic, strong) SAFormViewModel *firstResponderModel;
@property (nonatomic, strong) TZImagePickerController *adsIconPicker;
@end
static NSString * const kJumpSelectCell = @"kJumpSelectCell";
static NSString * const kInputCell = @"kInputCell";
static NSString * const kSwitchCell = @"kSwitchCell";
static NSString * const kChoseImgCell = @"kChoseImgCell";
static NSString * const kTextViewCell = @"kTextViewCell";
static NSString * const kMultiPhotoCell = @"kMultiPhotoCell";
static NSString * const kMultiAreaCell = @"kMultiAreaCell";
static NSString * const kMultiChannelCell = @"kMultiChannelCell";
static NSString * const kSwitchAndJumpCell = @"kSwitchAndJumpCell";
static NSString * const kAdsLinkUrlCellTitle = @"广告链接";
static NSString * const kAdsContentCellTitle = @"广告内容";
static NSString * const kAdsImgsCellTitle = @"广告图片";
@implementation SAFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackItem];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publish)];
    rightItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = rightItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstResponderNotification:) name:SAFormViewModelFirstResponderNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDismiss:) name:UIKeyboardWillHideNotification object:nil];
    [self p_setupTableView];
}
- (void)firstResponderNotification:(NSNotification *)notification {
    UIResponder *responder = notification.userInfo[@"responder"];
    id model = notification.userInfo[@"model"];
    BOOL isFirstResponder = [notification.userInfo[@"becomeFirstResponder"] boolValue];
    if (isFirstResponder) {
        self.firstResponder = responder;
        self.firstResponderModel = [model isEqual:[NSNull null]]?nil:model;
    }
    else {
        self.firstResponder = nil;
        self.firstResponderModel = nil;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [_hasUrlCell removeObserver:self forKeyPath:@"switchStatus"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)p_setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.sectionHeaderHeight = 15;
    _tableView.sectionFooterHeight = 0.1;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SAFormJumpSelectCell class]) bundle:nil] forCellReuseIdentifier:kJumpSelectCell];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SAFormInputCell class]) bundle:nil] forCellReuseIdentifier:kInputCell];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SAFormSwitchCell class]) bundle:nil] forCellReuseIdentifier:kSwitchCell];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SAFromChoseImageCell class]) bundle:nil] forCellReuseIdentifier:kChoseImgCell];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SAFormTextViewCell class]) bundle:nil] forCellReuseIdentifier:kTextViewCell];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SAFormMultiImgCell class]) bundle:nil] forCellReuseIdentifier:kMultiPhotoCell];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SAFormShareChannelCell class]) bundle:nil] forCellReuseIdentifier:kMultiChannelCell];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SAFormSwitchAndJumpCell class]) bundle:nil] forCellReuseIdentifier:kSwitchAndJumpCell];
    [_tableView registerClass:[SAFormMultiSelectCell class] forCellReuseIdentifier:kMultiAreaCell];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    SAFormViewModel *tradeCell = [[SAFormViewModel alloc] initWithStyle:SAFormCellStyleJump ID:SAFormIDIndusty];
    tradeCell.title = @"选择行业";
    SAFormViewModel *userMobile = [[SAFormViewModel alloc] initWithStyle:SAFormCellStyleInput ID:SAFormIDCompany];
    userMobile.title = @"手机号码";
    userMobile.placeHolder = @"请输入手机号码";
//    SAFormViewModel *adsTitleCell = [[SAFormViewModel alloc] initWithStyle:SAFormCellStyleInput ID:SAFormIDAdsTitle];
//    adsTitleCell.title = @"广告内容";
//    adsTitleCell.placeHolder = @"请输入广告标题";
//    adsTitleCell.keyboardType = UIKeyboardTypeDefault;
    SAFormViewModel *contentCell = [[SAFormViewModel alloc] initWithStyle:SAFormCellStyleTextView ID:SAFormIDContent];
    
    contentCell.title = kAdsContentCellTitle;
    SAFormViewModel *adsIconCell = [[SAFormViewModel alloc] initWithStyle:SAFormCellStyleChoseImg ID:SAFormIDAdsIcon];
    adsIconCell.title = @"广告图标";
    self.adsIconCellModel = adsIconCell;
    SAFormViewModel *priceCell = [[SAFormViewModel alloc] initWithStyle:SAFormCellStyleInput ID:SAFormIDPrice];
    priceCell.title = @"分享单价";
    priceCell.placeHolder = @"请输入单价";
    priceCell.keyboardType = UIKeyboardTypeDecimalPad;
    SAFormViewModel *amountCell = [[SAFormViewModel alloc] initWithStyle:SAFormCellStyleInput ID:SAFormIDAmount];
    amountCell.title = @"分享总价";
    amountCell.placeHolder = @"请输入总价";
    amountCell.keyboardType = UIKeyboardTypeDecimalPad;
    SAFormViewModel *hasUrlCell = [[SAFormViewModel alloc] initWithStyle:SAFormCellStyleSwitch ID:SAFormIDIsHaveUrl];
    hasUrlCell.title = @"是否有广告链接";
    hasUrlCell.switchStatus = YES;
    [hasUrlCell addObserver:self forKeyPath:@"switchStatus" options:NSKeyValueObservingOptionNew context:nil];
    self.hasUrlCell = hasUrlCell;
    SAFormViewModel *adsUrlCell = [[SAFormViewModel alloc] initWithStyle:SAFormCellStyleInput ID:SAFormIDLinkUrl];
    adsUrlCell.title = kAdsLinkUrlCellTitle;
    adsUrlCell.placeHolder = @"请输入您的广告链接";
    adsUrlCell.keyboardType = UIKeyboardTypeURL;
    SAFormViewModel *allowShareCountCell = [[SAFormViewModel alloc] initWithStyle:SAFormCellStyleInput ID:SAFormIDAllowShareCount];
    allowShareCountCell.title = @"每日分享次数上限";
    allowShareCountCell.placeHolder = @"请输入分享次数上限";
    allowShareCountCell.keyboardType = UIKeyboardTypeNumberPad;
    SAFormViewModel *allowShareTimeCell = [[SAFormViewModel alloc] initWithStyle:SAFormCellStyleJump ID:SAFormIDAllowShareTime];
    allowShareTimeCell.title = @"允许分享时段";
    SAFormViewModel *allowShareAreaCell = [[SAFormViewModel alloc] initWithStyle:SAFormCellStyleMultiSelectArea ID:SAFormIDAllowShareArea];
    allowShareAreaCell.title = @"允许分享地区";
    SAFormViewModel *allowShareChannelCell = [[SAFormViewModel alloc] initWithStyle:SAFormCellStyleMultiSelectShareChannel ID:SAFormIDAllowShareChannel];
    allowShareChannelCell.title = @"允许分享渠道";
    SAFormViewModel *needInvoiceCell = [[SAFormViewModel alloc] initWithStyle:SAFormCellStyleSwitch ID:SAFormIDneedInvoice];
    needInvoiceCell.switchStatus = NO;
    needInvoiceCell.title = @"需要发票";
    SAFormViewModel *recommderCell = [[SAFormViewModel alloc] initWithStyle:SAFormCellStyleInput ID:SAFormIDRecommender];
    recommderCell.title = @"邀请码";
    recommderCell.placeHolder = @"请输入您的推荐人邀请码";
    
    SAFormViewModel *agreementCell = [[SAFormViewModel alloc] initWithStyle:SAFormCellStyleSwitchAndJump ID:SAFormIDAgreement];
    agreementCell.title = @"我已同意服务协议";
    agreementCell.switchStatus = NO;
    self.dataSource = @[tradeCell,userMobile,contentCell,priceCell,amountCell,allowShareCountCell,recommderCell,allowShareAreaCell,allowShareTimeCell,allowShareChannelCell,needInvoiceCell,hasUrlCell,agreementCell,adsIconCell,adsUrlCell];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAFormViewModel *model = self.dataSource[indexPath.section];
    SAFormBaseCell *cell;
    switch (model.style) {
        case SAFormCellStyleJump:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kJumpSelectCell forIndexPath:indexPath];
            cell.model = model;
        }
            break;
        case SAFormCellStyleInput:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kInputCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model;
        }
            break;
        case SAFormCellStyleSwitch:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kSwitchCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model;
        }
            break;
        case SAFormCellStyleChoseImg:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kChoseImgCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model;
            
        }
            break;
        case SAFormCellStyleTextView:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kTextViewCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model;
        }
            break;
        case SAFormCellStyleMultiPhotos:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kMultiPhotoCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model;
        }
            break;
        case SAFormCellStyleMultiSelectArea:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kMultiAreaCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model;
            SAFormMultiSelectCell *multiCell = (SAFormMultiSelectCell *)cell;
            __weak typeof(self) weakSelf = self;
            multiCell.deleteBlock = ^{
//                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            };
            multiCell.addBlock = ^{
                [weakSelf tableView:weakSelf.tableView didSelectRowAtIndexPath:indexPath];
            };
        }
            break;
        case SAFormCellStyleMultiSelectShareChannel:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kMultiChannelCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model;
        }
            break;
        case SAFormCellStyleSwitchAndJump: {
            cell = [tableView dequeueReusableCellWithIdentifier:kSwitchAndJumpCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model;
            break;
        }
        default:
            cell = [SAFormBaseCell new];
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SAFormViewModel *model = _dataSource[indexPath.section];
    if (model.ID == SAFormIDIndusty) {
        SASelectTradeViewController *vc = [SASelectTradeViewController new];
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        vc.delegate = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:vc animated:NO completion:nil];
        });
    }
    if (model.ID == SAFormIDAllowShareArea) {
        NSArray *array = model.commitObj;
        if (array.count >= SAFormMultiSelectCellMaxArea) {
            [SVProgressHUD showErrorWithStatus:@"最多选四个区域"];
            return;
        }
        SASelectAreaController *vc = [SASelectAreaController new];
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        vc.delegate = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:vc animated:NO completion:nil];
        });
    }
    if (model.ID == SAFormIDAdsIcon) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        imagePickerVc.photoWidth = 300;
        imagePickerVc.allowPickingOriginalPhoto = NO;
        imagePickerVc.allowCrop = YES;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        imagePickerVc.cropRect = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - width)/2, width, width);
        [self presentViewController:imagePickerVc animated:YES completion:nil];
        self.adsIconPicker = imagePickerVc;
        
    }
    if (model.ID == SAFormIDAllowShareTime) {
        SAFormSelectShareTimeController *vc = [SAFormSelectShareTimeController new];
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        vc.delegate = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:vc animated:NO completion:nil];
        });
    }
    if (model.ID == SAFormIDAgreement) {
        CommonWebViewController *webvc = [CommonWebViewController new];
        webvc.urlStr = @"https://www.baidu.com";
        [self.navigationController pushViewController:webvc animated:YES];
    }
    [self.firstResponder resignFirstResponder];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAFormViewModel *model = self.dataSource[indexPath.section];
    if (model.ID == SAFormIDContent) {
        return 60;
    }
    if (model.ID == SAFormIDAllowShareArea) {
        return [SAFormMultiSelectCell heightForModel:model];
    }
    if (model.ID == SAFormIDAllowShareChannel) {
        return 60;
    }
    return 45;
}
#pragma mark - pickerView的delegate们
- (void)selectTradeViewController:(SASelectTradeViewController *)vc didSelectTrade:(Trade *)trade {
    __block SAFormViewModel *selectedModel = nil;
    [_dataSource indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SAFormViewModel *model = obj;
        if (model.ID == SAFormIDIndusty ) {
            selectedModel = model;
            return YES;
        }
        else {
            return NO;
        }
    }];
    selectedModel.placeHolder = trade.desc;
    selectedModel.commitObj = trade.id;
//    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:[_dataSource indexOfObject:selectedModel] inSection:0];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:[_dataSource indexOfObject:selectedModel] ] withRowAnimation:UITableViewRowAnimationNone];
//    [_tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)selectAreaController:(SASelectAreaController *)sexvc didSelectProvince:(Province *)province city:(City *)city district:(District *)district {
    __block SAFormViewModel *selectedModel = nil;
    NSInteger index = [_dataSource indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SAFormViewModel *model = obj;
        if (model.ID == SAFormIDAllowShareArea ) {
            selectedModel = model;
            return YES;
        }
        else {
            return NO;
        }
    }];
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] init];
    if (province != nil) {
        [mutDic setObject:province.provId forKey:@"provinceCode"];
    }
    if (city != nil) {
        [mutDic setObject:city.cityId forKey:@"cityCode"];
    }
    if (district != nil) {
        [mutDic setObject:district.areaId forKey:@"areaCode"];
    }
    if (selectedModel.commitObj == nil) {
        selectedModel.commitObj = @[mutDic];
//        selectedModel.commitObj = @[@{@"provinceCode":province != nil ? province.provId:@"",@"cityCode":city != nil ? city.cityId:@"",@"areaCode":district != nil ? district.areaId:@""}];
    }
    else {
        NSMutableArray *array = [NSMutableArray arrayWithArray:selectedModel.commitObj];
        [array addObject:mutDic];
        selectedModel.commitObj = array;
    }
//    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)selectShareTimeController:(SAFormSelectShareTimeController *)vc didSelectTime:(NSString *)time {
    __block SAFormViewModel *selectedModel = nil;
    [_dataSource indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SAFormViewModel *model = obj;
        if (model.ID == SAFormIDAllowShareTime ) {
            selectedModel = model;
            return YES;
        }
        else {
            return NO;
        }
    }];
    if ([time isEqualToString:@"01"]) {
        selectedModel.placeHolder = @"无限制";
    }
    else if ([time isEqualToString:@"02"]){
        selectedModel.placeHolder = @"周末";
    }
    else if ([time isEqualToString:@"03"]) {
        selectedModel.placeHolder = @"工作日";
    }
    selectedModel.commitObj = time;
//    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:[_dataSource indexOfObject:selectedModel] inSection:0];
//    [_tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:[_dataSource indexOfObject:selectedModel]] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 观察者
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"");
    if ([keyPath isEqualToString:@"switchStatus"]) {
        BOOL switchStatus = [change[NSKeyValueChangeNewKey] boolValue];
        if (switchStatus == YES) {
//            NSInteger contentCellIndex = 9999;
//            BOOL contentFound = NO;
//            for (NSInteger i = _dataSource.count - 1; i > 0; i--) {
//                SAFormViewModel *model = _dataSource[i];
//                
//                if ([model.title isEqualToString:kAdsContentCellTitle]) {
//                    contentCellIndex = i;
//                    contentFound = YES;
//                    break;
//                }
//            }
//            if (contentFound) {
//                NSMutableArray *mutDataSource = [NSMutableArray arrayWithArray:_dataSource];
//                [mutDataSource removeObjectAtIndex:contentCellIndex];
//                _dataSource = [mutDataSource copy];
//                [_tableView beginUpdates];
//                [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:contentCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
//                [_tableView endUpdates];
//                
//            }
            NSInteger multiPhotoCellIndex = 9999;
            BOOL imgFound = NO;
            for (NSInteger i = _dataSource.count - 1; i > 0; i--) {
                SAFormViewModel *model = _dataSource[i];
                if ([model.title isEqualToString:kAdsImgsCellTitle]) {
                    multiPhotoCellIndex = i;
                    imgFound = YES;
                    break;
                }
            }
            if (imgFound) {
                NSMutableArray *mutDataSource = [NSMutableArray arrayWithArray:_dataSource];
                [mutDataSource removeObjectAtIndex:multiPhotoCellIndex];
                _dataSource = [mutDataSource copy];
                [_tableView beginUpdates];
//                [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:multiPhotoCellIndex]] withRowAnimation:UITableViewRowAnimationRight];
                [_tableView deleteSections:[NSIndexSet indexSetWithIndex:multiPhotoCellIndex] withRowAnimation:UITableViewRowAnimationRight];
                [_tableView endUpdates];
            }
            
            SAFormViewModel *adsUrlCell = [[SAFormViewModel alloc] initWithStyle:SAFormCellStyleInput ID:SAFormIDLinkUrl];
            adsUrlCell.title = kAdsLinkUrlCellTitle;
            adsUrlCell.placeHolder = @"请输入您的广告链接";
            adsUrlCell.keyboardType = UIKeyboardTypeURL;
            NSMutableArray *mutDataSource = [NSMutableArray arrayWithArray:_dataSource];
            [mutDataSource addObject:adsUrlCell];
            _dataSource = [mutDataSource copy];
            [_tableView beginUpdates];
//            [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:[_dataSource indexOfObject:adsUrlCell]]] withRowAnimation:UITableViewRowAnimationLeft];
            [_tableView insertSections:[NSIndexSet indexSetWithIndex:[_dataSource indexOfObject:adsUrlCell]] withRowAnimation:UITableViewRowAnimationLeft];
            [_tableView endUpdates];
        }
        else {
            NSInteger linkUrlCellIndex = 9999;
            for (NSInteger i = _dataSource.count - 1; i > 0; i--) {
                SAFormViewModel *model = _dataSource[i];
                if ([model.title isEqualToString:kAdsLinkUrlCellTitle]) {
                    linkUrlCellIndex = i;
                    break;
                }
            }
            if (linkUrlCellIndex != 9999) {
                NSMutableArray *mutDataSource = [NSMutableArray arrayWithArray:_dataSource];
                [mutDataSource removeObjectAtIndex:linkUrlCellIndex];
                _dataSource = [mutDataSource copy];
                [_tableView beginUpdates];
//                [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:linkUrlCellIndex]] withRowAnimation:UITableViewRowAnimationLeft];
                [_tableView deleteSections:[NSIndexSet indexSetWithIndex:linkUrlCellIndex] withRowAnimation:UITableViewRowAnimationLeft];
                [_tableView endUpdates];
            }
//            SAFormViewModel *contentCell = [[SAFormViewModel alloc] initWithStyle:SAFormCellStyleTextView ID:SAFormIDContent];
//            contentCell.title = kAdsContentCellTitle;
            SAFormViewModel *multiPhotoCell = [[SAFormViewModel alloc] initWithStyle:SAFormCellStyleMultiPhotos ID:SAFormIDImgList];
            multiPhotoCell.title = kAdsImgsCellTitle;
            NSMutableArray *mut = [NSMutableArray arrayWithArray:_dataSource];
            [mut addObjectsFromArray:@[multiPhotoCell]];
            _dataSource = [mut copy];
//            NSIndexPath *contentPath = [NSIndexPath indexPathForRow:[_dataSource indexOfObject:contentCell] inSection:0];
            NSIndexPath *multiPhotoPath = [NSIndexPath indexPathForRow:0 inSection:[_dataSource indexOfObject:multiPhotoCell]];
            [_tableView beginUpdates];
//            [_tableView insertRowsAtIndexPaths:@[multiPhotoPath] withRowAnimation:UITableViewRowAnimationRight];
            [_tableView insertSections:[NSIndexSet indexSetWithIndex:multiPhotoPath.section] withRowAnimation:UITableViewRowAnimationRight];
            [_tableView endUpdates];
        }        
    }
}

- (void)publish {
    [self.firstResponder resignFirstResponder];
    NSMutableDictionary *mutParam = [NSMutableDictionary new];
    float price = 0 ;
    float amout = 0;
    for (int i = 0; i < self.dataSource.count; i++) {
        SAFormViewModel *model = self.dataSource[i];
        switch (model.ID) {
            case SAFormIDAgreement: {
                if (![model.commitObj isEqualToString:@"Y"]) {
                    [SVProgressHUD showInfoWithStatus:@"您必须同意服务协议才能发布广告"];
                    return;
                }
                break;
            }
            case SAFormIDIndusty: {
                if (model.commitObj == nil) {
                    [SVProgressHUD showErrorWithStatus:@"请您选择行业"];
                    return ;
                }
                [mutParam setObject:model.commitObj forKey:@"tradeId"];
            }
                break;
            case SAFormIDCompany: {
                if (model.commitObj == nil) {
                    [SVProgressHUD showErrorWithStatus:@"请您输入您的公司名称"];
                    return;
                }
                [mutParam setObject:model.commitObj forKey:@"userCompany"];
            }
                break;
            case SAFormIDAdsTitle:{
                if (model.commitObj == nil) {
                    [SVProgressHUD showErrorWithStatus:@"请您输入广告标题"];
                    return;
                }
                [mutParam setObject:model.commitObj forKey:@"title"];
            }
                break;
            case SAFormIDPrice:
            {
                NSString *priceStr = model.commitObj;
                if (model.commitObj == nil) {
                    [SVProgressHUD showErrorWithStatus:@"您未选择输入广告单价"];
                    return;
                }
                else {
                    price = [priceStr floatValue];
                    if (price == 0) {
                        [SVProgressHUD showErrorWithStatus:@"广告单价输入有误，请重新输入"];
                        return;
                    }
                }
                [mutParam setObject:priceStr forKey:@"price"];
            }
                break;
            case SAFormIDAmount:
            {
                NSString *amoutStr = model.commitObj;
                if (model.commitObj == nil) {
                    [SVProgressHUD showErrorWithStatus:@"您未选择输入广告总价"];
                    return;
                }
                else {
                    amout = [amoutStr floatValue];
                    if (amout == 0) {
                        [SVProgressHUD showErrorWithStatus:@"广告总价输入有误，请重新输入"];
                        return;
                    }
                }
                [mutParam setObject:amoutStr forKey:@"amount"];
            }
                break;
            case SAFormIDIsHaveUrl:
            {
                if (model.commitObj == nil) {
                    [SVProgressHUD showErrorWithStatus:@"您有没有广告URL？"];
                    return;
                }
                [mutParam setObject:model.commitObj forKey:@"isHaveUrl"];
            }
                break;
            case SAFormIDAllowShareCount:
            {
                if (model.commitObj == nil) {
                    [SVProgressHUD showErrorWithStatus:@"请输入广告分享次数上限"];
                    return;
                }
                else if([model.commitObj integerValue] == 0) {
                    [SVProgressHUD showErrorWithStatus:@"广告分享次数上限输入有误"];
                    return;
                }
                [mutParam setObject:model.commitObj forKey:@"allowShareCount"];
            }
                break;
            case SAFormIDAllowShareChannel:
            {
                if (model.commitObj == nil) {
                    [SVProgressHUD showErrorWithStatus:@"请输选择分享渠道"];
                    return;
                }
                [mutParam setObject:model.commitObj forKey:@"allowShareChannel"];
            }
                break;
            case SAFormIDAllowShareTime:
            {
                if (model.commitObj == nil) {
                    [SVProgressHUD showErrorWithStatus:@"请输选择分享时限"];
                    return;
                }
                [mutParam setObject:model.commitObj forKey:@"allowShareTime"];
            }
                break;
            case SAFormIDAllowShareArea:
            {
                if (model.commitObj == nil) {
                    [SVProgressHUD showErrorWithStatus:@"请输选择分享地区"];
                    return;
                }
                [mutParam setObject:model.commitObj forKey:@"allowShareArea"];
            }
                break;
            case SAFormIDneedInvoice:
            {
                if (model.commitObj == nil) {
                    [SVProgressHUD showErrorWithStatus:@"需要发票？"];
                    return;
                }
                [mutParam setObject:model.commitObj forKey:@"needInvoice"];
            }
                break;
            case SAFormIDRecommender:
            {
                if (model.commitObj != nil) {
                    [mutParam setObject:model.commitObj forKey:@"recommender"];
                }
            }
                break;
            case SAFormIDContent:
            {
                if (model.commitObj == nil) {
                    [SVProgressHUD showErrorWithStatus:@"请输入广告内容"];
                    return;
                }
                [mutParam setObject:model.commitObj forKey:@"content"];
            }
                break;
            case SAFormIDLinkUrl:
            {
                if (model.commitObj == nil) {
                    [SVProgressHUD showErrorWithStatus:@"请输入广告链接"];
                    return;
                }
                [mutParam setObject:model.commitObj forKey:@"url"];
            }
                break;
            case SAFormIDUserMobile:
            {
                if (model.commitObj == nil) {
                    [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
                    return;
                }
                [mutParam setObject:model.commitObj forKey:@"phone"];
            }
                break;
            default:
                break;
        }
    }
//    "imgList": "3d2c4ad7-cb20-48a4-8aef-b3f3c5f0897f"
    [mutParam setObject:@"3d2c4ad7-cb20-48a4-8aef-b3f3c5f0897f" forKey:@"imgList"];
//    "content": "内容"
    [mutParam setObject:@"内容" forKey:@"content"];
    [SVProgressHUD show];
    dispatch_group_t uploadImgGroup = dispatch_group_create();
    __block SAFormViewModel *imgListModel = nil;
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SAFormViewModel *model = obj;
        if (model.ID == SAFormIDImgList) {
            imgListModel = obj;
            *stop = YES;
        }
    }];
    NSMutableArray<SAUploadImgeStatusModel *> *adsImgsModel = [NSMutableArray new];
    if (imgListModel != nil) {
        if (imgListModel.selectedImgs.count > 0) {
            [imgListModel.selectedImgs enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIImage *adsImg = obj;
                SAUploadImgeStatusModel *imgeModel = [[SAUploadImgeStatusModel alloc] initWithImage:adsImg];
                imgeModel.status = SAUploadImgeStatusUploading;
                [adsImgsModel addObject:imgeModel];
                dispatch_group_enter(uploadImgGroup);
               [[NetworkManager shareManager] uploadImage:adsImg progress:^(NSProgress * _Nonnull uploadProgress) {
                   imgeModel.status = SAUploadImgeStatusUploading;
                   imgeModel.progress = uploadProgress.fractionCompleted;
               } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   imgeModel.status = SAUploadImgeStatusSuccess;
                   imgeModel.fileId = responseObject[@"fileId"];
                   dispatch_group_leave(uploadImgGroup);
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   imgeModel.status = SAUploadImgeStatusFailure;
                   imgeModel.status = SAUploadImgeStatusSuccess;
                   dispatch_group_leave(uploadImgGroup);
               }];
            }];
        }
    }
    //上传广告icon
    if (self.adsIconCellModel.selectedImg == nil) {
        [SVProgressHUD showErrorWithStatus:@"请为您的广告选择一个封面"];
        return;
    }
    UIImage *iconImg = self.adsIconCellModel.selectedImg;
    SAUploadImgeStatusModel *iconModel = [[SAUploadImgeStatusModel alloc] initWithImage:iconImg];
    dispatch_group_enter(uploadImgGroup);
    [[NetworkManager shareManager] uploadImage:iconImg progress:^(NSProgress * _Nonnull uploadProgress) {
        iconModel.status = SAUploadImgeStatusUploading;
        iconModel.progress = uploadProgress.fractionCompleted;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        iconModel.status = SAUploadImgeStatusSuccess;
        iconModel.fileId = responseObject[@"fileId"];
        self.adsIconCellModel.commitObj = iconModel.fileId;
        dispatch_group_leave(uploadImgGroup);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        iconModel.status = SAUploadImgeStatusFailure;
        dispatch_group_leave(uploadImgGroup);
    }];
    dispatch_group_notify(uploadImgGroup, dispatch_get_main_queue(), ^{
        NSLog(@"上传图片完成");
        if (iconModel.status == SAUploadImgeStatusFailure) {
            [SVProgressHUD showErrorWithStatus:@"广告封面上传失败，请重试"];
            return ;
        }
        else if(iconModel.fileId != nil){
            [mutParam setObject:iconModel.fileId forKey:@"iconImage"];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"后台正忙，请稍后重试"];
            return;
        }
        NSMutableArray *adsImgsIds = [NSMutableArray new];
        [adsImgsModel enumerateObjectsUsingBlock:^(SAUploadImgeStatusModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.status == SAUploadImgeStatusFailure) {
                [SVProgressHUD showErrorWithStatus:@"广告图片上传失败，请重试"];
                return ;
            }
            else if (obj.fileId != nil){
                [adsImgsIds addObject:obj.fileId];
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"后台正忙，请稍后重试"];
                return;
            }
        }];
        if (adsImgsIds.count > 0) {
            [mutParam setObject:adsImgsIds forKey:@"imgList"];
        }
        //将数据提交后台
        [NetworkInterface releaseAd:mutParam success:^(NSDictionary *response) {
            [SVProgressHUD showSuccessWithStatus:@"广告上传成功！"];
        } failure:^(NSString *message, NSInteger errorCode) {
            [SVProgressHUD dismiss];
        }];
        
    });
    
}
- (void)keyBoardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo =  notification.userInfo;
//    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSInteger index = [self.dataSource indexOfObject:self.firstResponderModel];
    CGRect rect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect rectInWindow = [self.tableView convertRect:rect toView:keyWindow];
    CGFloat deltaY = CGRectGetMaxY(rectInWindow) - keyboardEndFrame.origin.y;
    if (deltaY > 0) {//键盘遮住
        _tableView.contentOffset = CGPointMake(_tableView.contentOffset.x, _tableView.contentOffset.y + deltaY);
    }
    NSLog(@"");
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    __block SAFormViewModel *selectedModel = nil;
    _adsIconCellModel.selectedImg = photos[0];
    NSInteger index = [_dataSource indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SAFormViewModel *model = obj;
        if (model.ID == SAFormIDAdsIcon ) {
            selectedModel = model;
            return YES;
        }
        else {
            return NO;
        }
    }];
//    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
//    [_tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)keyboardWillDismiss:(NSNotification *)notification {
    
}
@end

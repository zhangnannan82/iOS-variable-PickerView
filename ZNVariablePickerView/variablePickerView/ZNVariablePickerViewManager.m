//
//  CMBAlterablePickerView.m
//  Eloan
//
//  Created by ZN on 2017/12/1.
//  Copyright © 2017年 ZN. All rights reserved.
//

#import "ZNVariablePickerViewManager.h"
#import "ZNVariablePickerView.h"

@interface ZNVariablePickerViewManager ()

@property (nonatomic, strong) NSMutableArray *dataArray;//国家
@property (nonatomic, strong) NSMutableArray *provinceArr;//省
@property (nonatomic, strong) NSMutableArray *citiesArray;//市
@property (nonatomic, strong) NSMutableArray *areasArray;//区
@property (nonatomic, strong) ZNVariablePickerView *variablePickerView;
@property (nonatomic, strong) NSMutableDictionary *infoParam;//回调时返回的参数
@property (nonatomic, assign) NSInteger allNumber;//最多显示列数

@end

@implementation ZNVariablePickerViewManager

+ (instancetype)sharedInstance {
    static id   sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

#pragma mark - show -
- (void)show {
    self.infoParam = [NSMutableDictionary dictionaryWithCapacity:0];
    if (self.dataArray == nil) {
        [self loadData];
    }
    else {
        [self configSubViews];
    }
}

- (void)loadData {
    NSDictionary *resultDic = [NSDictionary dictionaryWithContentsOfFile:self.addressUrl];
    self.dataArray = resultDic[@"countryList"];
    self.allNumber = [resultDic[@"addrLevelNum"] integerValue];
    if ([self.dataArray count] > 0) {
        [self configSubViews];
    }
}

- (void)configSubViews {
    self.allNumber = self.allNumber <= 0 ? 0 : self.allNumber;
    self.startIndex = self.startIndex < 0 ? 0 : self.startIndex;
    self.startIndex = self.startIndex >= self.allNumber ? self.allNumber - 1 : self.startIndex;
    self.numberOfComponents = self.numberOfComponents > (self.allNumber - self.startIndex) ? self.allNumber - self.startIndex : self.numberOfComponents;
    self.numberOfComponents = self.numberOfComponents < 1 ? 1 : self.numberOfComponents;
    
    self.variablePickerView = [[ZNVariablePickerView alloc] initWithTitle:self.title     DataArray:self.dataArray titleForRowKey:self.titleKey valueKey:self.valueKey allNumber:self.allNumber startIndex:self.startIndex numberOfCouponType:self.numberOfComponents];
     __weak typeof(self) weakSelf = self;
     self.variablePickerView.submitBlock = ^(NSDictionary *resultDict, NSInteger row){
        //省、市、区需要分开来传
        weakSelf.infoParam[@"pro"] = resultDict[@"province"];        // 省
        weakSelf.infoParam[@"city"] = resultDict[@"city"];      // 市
        weakSelf.infoParam[@"district"] = resultDict[@"area"];  // 区
        weakSelf.infoParam[@"cityNumber"] = resultDict[@"cityNumber"];// 编号
        [weakSelf.variablePickerView quit];
        if (weakSelf.submitBlock) {
            weakSelf.submitBlock(weakSelf.infoParam);
        }
    };
    [self.variablePickerView show];
    
    self.variablePickerView.cancelBlock = ^{
        [weakSelf.variablePickerView quit];
    };
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.variablePickerView quit];
}

@end

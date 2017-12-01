//
//  CMBAlterablePickerView.h
//  Eloan
//
//  Created by ZN on 2017/12/1.
//  Copyright © 2017年 ZN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 * @brief 选择的省市区时，result是省(pro)市(city)区(area)三个字段
 */
typedef void(^submitAddressBlock)(NSDictionary *resultDict);

@interface ZNVariablePickerViewManager : NSObject

@property (nonatomic, strong) NSString *addressUrl;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *titleKey;
@property (nonatomic, strong) NSString *valueKey;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger numberOfComponents;
@property (nonatomic, copy) submitAddressBlock submitBlock;

+ (instancetype)sharedInstance;
- (void)show;

@end






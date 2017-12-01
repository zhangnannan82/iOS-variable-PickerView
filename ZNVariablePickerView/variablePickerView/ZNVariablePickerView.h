//
//  CMBVariablePickerView.h
//  Eloan
//
//  Created by ZN on 2017/12/1.
//  Copyright © 2017年 ZN. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 * @brief 选择的省市区时，result是省(pro)市(city)区(area)三个字段
 */
typedef void(^submitBlock)(NSDictionary *resultDict, NSInteger row);
typedef void(^cancelBlock)();

@interface ZNVariablePickerView : UIView

@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, copy) submitBlock submitBlock;
@property (nonatomic, copy) cancelBlock cancelBlock;
/*!
 * @brief 初始化方法
 * @param title 选择器的标题
 * @param array 选择数据
 * @param nameKey 取出选择数据的key
 * @param valueKey 取出编号的key
 * @param allNumber 所有的层
 * @param startIndex 开始的层：0开始
 * @param number 要显示的层
 */
- (instancetype)initWithTitle:(NSString *)title
                    DataArray:(NSArray *)array
               titleForRowKey:(NSString *)nameKey
                     valueKey:(NSString *)valueKey
                    allNumber:(NSInteger)allNumber
                   startIndex:(NSInteger)startIndex
           numberOfCouponType:(NSInteger)number;
- (void)show;
- (void)quit;

@end




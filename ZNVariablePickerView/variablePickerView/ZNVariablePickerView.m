//
//  CMBVariablePickerView.m
//  Eloan
//  Created by ZN on 2017/12/1.
//  Copyright © 2017年 ZN. All rights reserved.
//

#import "ZNVariablePickerView.h"

#define CMBVariablePickerViewH 260

@interface ZNVariablePickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, assign) NSInteger resultRow;
@property (nonatomic, strong) NSString *titleKey;
@property (nonatomic, strong) NSString *valueKey;
@property (nonatomic, strong) NSMutableDictionary *resultDict;
@property (nonatomic, strong) NSArray *dataArray;//国家
@property (nonatomic, strong) NSMutableArray *provinceArr;//省
@property (nonatomic, strong) NSMutableArray *citiesArray;//市
@property (nonatomic, strong) NSMutableArray *areasArray;//区
@property (nonatomic, assign) NSInteger allNumber;//总列数
@property (nonatomic, assign) NSInteger startIndex;//开始的层
@property (nonatomic, assign) NSInteger numberOfComponents;//要展示的列数

@end

@implementation ZNVariablePickerView

- (instancetype)initWithTitle:(NSString *)title DataArray:(NSArray *)array titleForRowKey:(NSString *)nameKey valueKey:(NSString *)valueKey allNumber:(NSInteger)allNumber startIndex:(NSInteger)startIndex  numberOfCouponType:(NSInteger)number {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.4];
        self.dataArray = array;
        self.titleKey = nameKey;
        self.valueKey = valueKey;
        self.allNumber = allNumber;
        self.startIndex = startIndex;
        //列数
        self.numberOfComponents = number;
        self.resultDict = [NSMutableDictionary dictionaryWithCapacity:0];
        self.resultRow = 0;
        
        self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, CMBVariablePickerViewH )];
        self.toolView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.toolView];
        
        //为view上面的两个角设置圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.toolView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.toolView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.toolView.layer.mask = maskLayer;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(10, 0, 50, 40);
        [cancelBtn setTitleColor:[UIColor colorWithRed:0 green:171.0/255 blue:243.0/255 alpha:1.0] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.toolView addSubview:cancelBtn];
        
        UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        enterBtn.frame = CGRectMake(self.frame.size.width - 60, 0, 50, 40);
        [enterBtn setTitleColor:[UIColor colorWithRed:0 green:171.0/255 blue:243.0/255 alpha:1.0] forState:UIControlStateNormal];
        [enterBtn setTitle:@"确定" forState:UIControlStateNormal];
        [enterBtn addTarget:self action:@selector(enterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.toolView addSubview:enterBtn];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancelBtn.frame), 7, self.frame.size.width - 100 - 40, 25)];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.text = title;
        titleLab.font = [UIFont boldSystemFontOfSize:17.0];
        [self.toolView addSubview:titleLab];
        
        //国家
        NSDictionary *countryDic = self.dataArray[0];
        self.resultDict[@"country"] = countryDic[self.titleKey];
        //省
        self.provinceArr = [NSMutableArray arrayWithArray:countryDic[@"provinceList"]];
        self.resultDict[@"province"] = self.provinceArr[0][self.titleKey];
       //市
        NSDictionary *dict = self.provinceArr[0];
        self.citiesArray = [NSMutableArray arrayWithArray:dict[@"cityList"]];
        self.resultDict[@"city"] = self.citiesArray[0][self.titleKey];
        NSString *cityNum = self.citiesArray[0][self.valueKey];
        //区
        NSDictionary *areaDict = self.citiesArray[0];
        self.areasArray = [NSMutableArray arrayWithArray:areaDict[@"areaList"]];
        self.resultDict[@"area"] = self.areasArray[0][self.titleKey];

        self.resultDict[@"cityNumber"] = cityNum;
        self.picker = [[UIPickerView alloc] init];
        self.picker.frame = CGRectMake(0, CGRectGetMaxY(cancelBtn.frame), self.frame.size.width, self.toolView.frame.size.height - cancelBtn.frame.size.height);
        self.picker.delegate = self;
        self.picker.dataSource = self;
        [self.picker selectRow:0 inComponent:0 animated:YES];
        [self.toolView addSubview:self.picker];
    }
    return self;
}

- (void)show {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = self.toolView.frame;
        rect.origin.y -= self.toolView.frame.size.height;
        self.toolView.frame = rect;
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)quit {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        CGRect rect = self.toolView.frame;
        rect.origin.y -= self.toolView.frame.size.height;
        self.toolView.frame = rect;
    }];
    [self removeFromSuperview];
}

- (void)cancelBtnClicked {
    if (_cancelBlock) {
        _cancelBlock();
    }
}

- (void)enterBtnClicked {
    if (self.submitBlock) {
        self.submitBlock(self.resultDict,self.resultRow);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_cancelBlock) {
        _cancelBlock();
    }
}

#pragma UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.numberOfComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //从第几级开始展示
    switch (self.startIndex) {
        case 0:
            if (component == 0) {
                return self.dataArray.count;
            }
            else if (component == 1) {
                return self.provinceArr.count;
            }
            else if (component == 2) {
                return self.citiesArray.count;
            }
            else {
                return self.areasArray.count;
            }
            break;
        case 1:
            if (component == 0) {
                return self.provinceArr.count;
            }
            else if (component == 1) {
                return self.citiesArray.count;
            }
            else {
                return self.areasArray.count;
            }
            break;
        case 2:
            if (component == 0) {
                return self.citiesArray.count;
            }
            else {
                return self.areasArray.count;
            }
            break;
        default:
            return self.areasArray.count;
            break;
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = nil;
    //从第几级开始展示
    switch (self.startIndex) {
        case 0:
            if (component == 0) {
                NSDictionary *dict = self.dataArray[row];
                title = dict[self.titleKey];
                return title;
            }
            else if (component == 1) {
                NSDictionary *dict = self.provinceArr[row];
                title = dict[self.titleKey];
                return title;
            }
            else if (component == 2) {
                NSDictionary *dict = self.citiesArray[row];
                title = dict[self.titleKey];
                return title;
            }
            else {
                NSDictionary *dict = self.areasArray[row];
                title = dict[self.titleKey];
                return title;
            }
            break;
        case 1:
            if (component == 0) {
                NSDictionary *dict = self.provinceArr[row];
                title = dict[self.titleKey];
                return title;
            }
            else if (component == 1) {
                NSDictionary *dict = self.citiesArray[row];
                title = dict[self.titleKey];
                return title;
            }
            else {
                NSDictionary *dict = self.areasArray[row];
                title = dict[self.titleKey];
                return title;
            }
            break;
        case 2:
            if (component == 0) {
                NSDictionary *dict = self.citiesArray[row];
                title = dict[self.titleKey];
                return title;
            }
            else {
                NSDictionary *dict = self.areasArray[row];
                title = dict[self.titleKey];
                return title;
            }
            break;
        default:
            return self.areasArray[row][self.titleKey];
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *countryStr = @"";
    NSString *proStr = @"";
    NSString *cityStr = @"";
    NSString *areaStr = @"";
    NSString *cityNumber = @"";
    if (self.startIndex == 0) {
        if (component == 0) {
            NSDictionary *dict = self.dataArray[row];
            self.provinceArr = dict[@"provinceList"];
            countryStr = dict[self.titleKey];
            proStr = dict[self.titleKey];
            cityStr = dict[self.titleKey];
            areaStr = dict[self.titleKey];
            if (self.provinceArr.count > 0) {
                NSDictionary *provinceDic = self.provinceArr[0];
                self.citiesArray = provinceDic[@"cityList"];
                proStr = provinceDic[self.titleKey];
                cityStr = provinceDic[self.titleKey];
                areaStr = provinceDic[self.titleKey];
                if (self.citiesArray.count > 0) {
                    NSDictionary *cityDict = self.citiesArray[0];
                    self.areasArray = cityDict[@"areaList"];
                    cityStr = cityDict[self.titleKey];
                    areaStr = cityDict[self.titleKey];
                    cityNumber = cityDict[self.valueKey];
                    if (self.areasArray.count) {
                        areaStr = self.areasArray[0][self.titleKey];
                    }
                    else {
                        /*self.titleKey : areaStr*/
                        NSMutableDictionary *areaDict = [[NSMutableDictionary alloc] init];
                        areaDict[self.titleKey] = areaStr;
                        areaDict[self.valueKey] = cityDict[self.valueKey];
                        [self.areasArray addObject:areaDict];
                    }
                }
                else {
                    /* self.titleKey : areaStr*/
                    NSMutableDictionary *cityDict = [[NSMutableDictionary alloc] init];
                    cityDict[self.titleKey] = areaStr;
                    cityDict[self.valueKey] = provinceDic[self.valueKey];
                    self.citiesArray = [NSMutableArray arrayWithObjects:cityDict, nil];
                    /*self.titleKey : areaStr*/
                    NSMutableDictionary *areaDict = [[NSMutableDictionary alloc] init];
                    areaDict[self.titleKey] = areaStr;
                    areaDict[self.valueKey] = provinceDic[self.valueKey];
                    self.areasArray = [NSMutableArray arrayWithObjects:areaDict, nil];
                }
            }
            self.resultDict[@"country"] = countryStr;
            self.resultDict[@"province"] = proStr;
            self.resultDict[@"city"] = cityStr;
            self.resultDict[@"area"] = areaStr;
            self.resultDict[@"cityNumber"] = cityNumber;
            [self.picker reloadAllComponents];
        }
        else if (component == 1) {
            NSDictionary *dict = self.provinceArr[row];
            self.citiesArray = dict[@"cityList"];
            proStr = dict[self.titleKey];
            cityStr = dict[self.titleKey];
            areaStr = dict[self.titleKey];
            if (self.citiesArray.count > 0) {
                NSDictionary *resultDict = self.citiesArray[0];
                self.areasArray = resultDict[@"areaList"];
                cityStr = resultDict[self.titleKey];
                areaStr = resultDict[self.titleKey];
                cityNumber = resultDict[self.valueKey];
                if (self.areasArray.count) {
                    areaStr = self.areasArray[0][self.titleKey];
                }
                else {
                    /*self.titleKey : areaStr*/
                    NSMutableDictionary *areaDict = [[NSMutableDictionary alloc] init];
                    areaDict[self.titleKey] = areaStr;
                    areaDict[self.valueKey] = resultDict[self.valueKey];
                    [self.areasArray addObject:areaDict];
                }
            }
            else {
                /* self.titleKey : areaStr*/
                NSMutableDictionary *cityDict = [[NSMutableDictionary alloc] init];
                cityDict[self.titleKey] = areaStr;
                cityDict[self.valueKey] = dict[self.valueKey];
                self.citiesArray = [NSMutableArray arrayWithObjects:cityDict, nil];
                /*self.titleKey : areaStr*/
                NSMutableDictionary *areaDict = [[NSMutableDictionary alloc] init];
                areaDict[self.titleKey] = areaStr;
                areaDict[self.valueKey] = dict[self.valueKey];
                self.areasArray = [NSMutableArray arrayWithObjects:areaDict, nil];
            }
            self.resultDict[@"province"] = proStr;
            self.resultDict[@"city"] = cityStr;
            self.resultDict[@"area"] = areaStr;
            self.resultDict[@"cityNumber"] = cityNumber;
            [self.picker reloadAllComponents];
        }
        else if (component == 2) {
            NSDictionary *resultDict = self.citiesArray[row];
            self.areasArray = resultDict[@"areaList"];
            cityStr = resultDict[self.titleKey];
            areaStr = resultDict[self.titleKey];
            cityNumber = resultDict[self.valueKey];
            if (self.areasArray.count > 0) {
                areaStr = self.areasArray[0][self.titleKey];
                cityNumber = self.areasArray[0][self.valueKey];
            }
            self.resultDict[@"city"] = cityStr;
            self.resultDict[@"area"] = areaStr;
            self.resultDict[@"cityNumber"] = cityNumber;
            [self.picker reloadAllComponents];
        }
        else {
            self.resultDict[@"area"] = self.areasArray[row][self.titleKey];
        }
    }
    else if (self.startIndex == 1) {
        if (component == 0) {
            NSDictionary *dict = self.provinceArr[row];
            self.citiesArray = dict[@"cityList"];
            proStr = dict[self.titleKey];
            cityStr = dict[self.titleKey];
            areaStr = dict[self.titleKey];
            if (self.citiesArray.count > 0) {
                NSDictionary *resultDict = self.citiesArray[0];
                self.areasArray = resultDict[@"areaList"];
                cityStr = resultDict[self.titleKey];
                areaStr = resultDict[self.titleKey];
                cityNumber = resultDict[self.valueKey];
                if (self.areasArray.count) {
                    areaStr = self.areasArray[0][self.titleKey];
                }
                else {
                    /*self.titleKey : areaStr*/
                    NSMutableDictionary *areaDict = [[NSMutableDictionary alloc] init];
                    areaDict[self.titleKey] = areaStr;
                    areaDict[self.valueKey] = resultDict[self.valueKey];
                    [self.areasArray addObject:areaDict];
                }
            }
            else {
                /* self.titleKey : areaStr*/
                NSMutableDictionary *cityDict = [[NSMutableDictionary alloc] init];
                cityDict[self.titleKey] = areaStr;
                cityDict[self.valueKey] = dict[self.valueKey];
                self.citiesArray = [NSMutableArray arrayWithObjects:cityDict, nil];
                /*self.titleKey : areaStr*/
                NSMutableDictionary *areaDict = [[NSMutableDictionary alloc] init];
                areaDict[self.titleKey] = areaStr;
                areaDict[self.valueKey] = dict[self.valueKey];
                self.areasArray = [NSMutableArray arrayWithObjects:areaDict, nil];
            }
            self.resultDict[@"province"] = proStr;
            self.resultDict[@"city"] = cityStr;
            self.resultDict[@"area"] = areaStr;
            self.resultDict[@"cityNumber"] = cityNumber;
            [self.picker reloadAllComponents];
        }
        else if (component == 1) {
            NSDictionary *resultDict = self.citiesArray[row];
            self.areasArray = resultDict[@"areaList"];
            cityStr = resultDict[self.titleKey];
            areaStr = resultDict[self.titleKey];
            cityNumber = resultDict[self.valueKey];
            if (self.areasArray.count > 0) {
                areaStr = self.areasArray[0][self.titleKey];
                cityNumber = self.areasArray[0][self.valueKey];
            }
            self.resultDict[@"city"] = cityStr;
            self.resultDict[@"area"] = areaStr;
            self.resultDict[@"cityNumber"] = cityNumber;
            [self.picker reloadAllComponents];
        }
        else {
            self.resultDict[@"area"] = self.areasArray[row][self.titleKey];
        }
    }
    else if (self.startIndex == 2) {
        if (component == 0) {
            NSDictionary *resultDict = self.citiesArray[row];
            self.areasArray = resultDict[@"areaList"];
            cityStr = resultDict[self.titleKey];
            areaStr = resultDict[self.titleKey];
            cityNumber = resultDict[self.valueKey];
            if (self.areasArray.count > 0) {
                areaStr = self.areasArray[0][self.titleKey];
                cityNumber = self.areasArray[0][self.valueKey];
            }
            self.resultDict[@"city"] = cityStr;
            self.resultDict[@"area"] = areaStr;
            self.resultDict[@"cityNumber"] = cityNumber;
            [self.picker reloadAllComponents];
        }
        else {
            self.resultDict[@"area"] = self.areasArray[row][self.titleKey];
        }
    }
    else {
        self.resultDict[@"area"] = self.areasArray[row][self.titleKey];
    }
}

@end

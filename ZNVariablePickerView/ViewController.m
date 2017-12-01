//
//  ViewController.m
//  ZNVariablePickerView
//
//  Created by ZN on 2017/12/1.
//  Copyright © 2017年 ZN. All rights reserved.
//

#import "ViewController.h"
#import "ZNVariablePickerViewManager.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) ZNVariablePickerViewManager *pickerViewManage;
//城市编号
@property (nonatomic, strong) NSString *cityNumber;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
}

- (void)configSubViews {
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, self.view.frame.size.width - 100, 50)];
    self.addressLabel.textColor = [UIColor whiteColor];
    self.addressLabel.backgroundColor = [UIColor colorWithRed:100.0/255 green:149.0/255 blue:237.0/255 alpha:1.0];
    self.addressLabel.text = @"请选择省市区";
    self.addressLabel.font = [UIFont systemFontOfSize:16];
    self.addressLabel.textAlignment = NSTextAlignmentCenter;
    self.addressLabel.layer.masksToBounds = YES;
    self.addressLabel.layer.cornerRadius = 5;
    [self.view addSubview:self.addressLabel];
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButton.frame = CGRectMake(100, 300, self.view.frame.size.width - 200, 50);
    [self.selectButton setTitle:@"选择城市" forState:UIControlStateNormal];
    [self.selectButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.selectButton.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:250.0/255 alpha:1.0];
    self.selectButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.selectButton.layer.masksToBounds = YES;
    self.selectButton.layer.cornerRadius = 5;
    [self.selectButton addTarget:self action:@selector(selectAddress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.selectButton];
}

-(void)selectAddress:(UIButton *)button {
    button.selected = !button.selected;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"addressList" ofType:@"plist"];
    self.pickerViewManage = [ZNVariablePickerViewManager sharedInstance];
    self.pickerViewManage.addressUrl = filePath;
    self.pickerViewManage.params = nil;
    self.pickerViewManage.title = nil;
    self.pickerViewManage.titleKey = @"name";
    self.pickerViewManage.valueKey = @"value";
    self.pickerViewManage.startIndex = 1;
    self.pickerViewManage.numberOfComponents = 3;
    [self.pickerViewManage show];
    __weak typeof(self) weakSelf = self;
    self.pickerViewManage.submitBlock = ^(NSDictionary *resultDict){
        NSString *proStr = resultDict[@"pro"];
        NSString *cityStr = resultDict[@"city"];
        NSString *areaStr = resultDict[@"district"];
        NSString *cityNum = resultDict[@"cityNumber"];  // 编号
        weakSelf.addressLabel.text = [NSString stringWithFormat:@"%@/%@/%@", proStr, cityStr, areaStr];
        weakSelf.cityNumber = cityNum;  // 编号
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

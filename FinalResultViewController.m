//
//  FinalResultViewController.m
//  Project-拼图
//
//  Created by apple on 16/02/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FinalResultViewController.h"

#define VIEW_WIDTH  self.view.frame.size.width
#define VIEW_HEIGHT self.view.frame.size.height

@interface FinalResultViewController ()

@end

@implementation FinalResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createResultLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createResultLabel{

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 200, VIEW_WIDTH - 200, 50)];
    label.text = @"游戏结果";
    label.font = [UIFont boldSystemFontOfSize:40];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

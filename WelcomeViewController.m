//
//  WelcomeViewController.m
//  Project-拼图
//
//  Created by apple on 16/02/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WelcomeViewController.h"
#import "GameViewController.h"
#import "FinalResultViewController.h"

#define VIEW_WIDTH  self.view.frame.size.width
#define VIEW_HEIGHT self.view.frame.size.height

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createButton{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 200, VIEW_WIDTH - 200, 50);
    [button setTitle:@"开始游戏" forState:UIControlStateNormal];
    button.layer.cornerRadius = 15;
    button.layer.borderWidth = 0.8;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    button.layer.borderColor = [[UIColor colorWithRed:0.143 green:0.092 blue:0.040 alpha:1.000]CGColor];
    [button addTarget:self action:@selector(begainGame:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(100, 270, VIEW_WIDTH - 200, 50);
    [button1 setTitle:@"查看排名" forState:UIControlStateNormal];
    button1.layer.cornerRadius = 15;
    button1.layer.borderWidth = 0.8;
    button1.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    button1.layer.borderColor = [[UIColor colorWithRed:0.143 green:0.092 blue:0.040 alpha:1.000]CGColor];
    [button1 addTarget:self action:@selector(searchResult:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button1];
}

- (void)begainGame:(UIButton *)button{

    GameViewController *gvc = [[GameViewController alloc]init];
    [self.navigationController pushViewController:gvc animated:YES];
}


- (void)searchResult:(UIButton *)button{

    FinalResultViewController *fvc = [[FinalResultViewController alloc]init];
    [self.navigationController pushViewController:fvc animated:YES];
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

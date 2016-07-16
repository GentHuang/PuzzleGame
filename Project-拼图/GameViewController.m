//
//  GameViewController.m
//  Project-拼图
//
//  Created by apple on 16/02/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GameViewController.h"
#import "ResultViewController.h"

#define VIEW_X      0
#define VIEW_Y      100
#define VIEW_WIDTH  [UIScreen mainScreen].bounds.size.width
#define VIEW_HEIGHT [UIScreen mainScreen].bounds.size.height
#define XCOUNT      3
#define YCOUNT      4
#define CUT_WIDTH   self.gameView.frame.size.width
#define CUT_HEIGHT  self.gameView.frame.size.height
#define XMOVE_STEP  CUT_WIDTH/XCOUNT
#define YMOVE_STEP  CUT_HEIGHT/YCOUNT

@interface GameViewController ()

@property (nonatomic, retain) UIImageView *gameView;
@property (nonatomic, retain) UIView *imageView;
@property (nonatomic, retain) UIImageView *whiteView;
@property (nonatomic, copy) NSMutableArray *array;
@property (nonatomic, copy) NSMutableArray *resultArray;
@property (nonatomic, copy) NSMutableArray *rectArray;

@end

@implementation GameViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    int a = arc4random()%25 + 1;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"美女%.2d.jpg", a]];
    [self createMainScreen:image];
    [self createProgress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//创建游戏主界面
- (void)createMainScreen:(UIImage *)image{

    _resultArray = [[NSMutableArray alloc]init];
    _rectArray = [[NSMutableArray alloc]init];
    _array = [[NSMutableArray alloc]init];
    if (self.gameView == nil) {
        self.gameView = [[UIImageView alloc]initWithImage:image];
    }
    [self setImage:image];
    [self.view addSubview:self.gameView];
    self.gameView.userInteractionEnabled = YES;
    self.imageView = [[UIView alloc]initWithFrame:CGRectMake(50, 65, VIEW_WIDTH - 100 + (XCOUNT + 1) * 2, VIEW_WIDTH - 100 + (YCOUNT + 1) * 2)];
    self.imageView.backgroundColor = [UIColor redColor];
    self.imageView.userInteractionEnabled = YES;
    [self.view addSubview:self.imageView];
    
    [self cutImage];
   
}
//设置游戏提示图片
- (void)setImage:(UIImage *)image{

    self.gameView.image = image;
    self.gameView.frame = CGRectMake(VIEW_X + 50, VIEW_HEIGHT - image.size.height + 285, VIEW_WIDTH - 100, VIEW_WIDTH - 100);

    self.gameView.contentMode = UIViewContentModeScaleAspectFit;
}
//切割图片
- (UIImage *)clipImage:(UIImage *)image withRect:(CGRect)rect
{
    CGImageRef CGImage = CGImageCreateWithImageInRect(image.CGImage, rect);
    return [UIImage imageWithCGImage:CGImage];
}


//切割图片
- (void)cutImage{

    NSUInteger tag = 10;

    for (NSUInteger i = 0; i < YCOUNT; i++) {
        for (NSUInteger j = 0; j < XCOUNT; j++) {

            CGRect rect = CGRectMake(CUT_WIDTH / XCOUNT * j + 2 * (j + 1), CUT_HEIGHT / YCOUNT * i + 2 * (i + 1), CUT_WIDTH / XCOUNT, CUT_HEIGHT / YCOUNT);
            NSString *string = NSStringFromCGRect(rect);
//            把坐标位置大小放入数组_rectArray中
            [_rectArray addObject:string];

            UIImage *returnImage = [self clipImage:self.gameView.image withRect:rect];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:returnImage];
            
            imageView.userInteractionEnabled = YES;
            imageView.tag = tag++;
//              将贴好图片的每一张图片放入数组_array中
            [_array addObject:imageView];
        
            imageView.frame = rect;
            
            
            if (i == YCOUNT - 1 && j == XCOUNT - 1) {
                _whiteView = [[UIImageView alloc]initWithFrame:rect];
                _whiteView.backgroundColor = [UIColor whiteColor];
                _whiteView.userInteractionEnabled = YES;
//                [self.imageView addSubview:_whiteView];
                _whiteView.tag = 22;
                NSString *string1 = NSStringFromCGRect(rect);
                [_rectArray addObject:string1];
                [_array addObject:_whiteView];
//                将未打乱顺序的数组存放在_resultArray中
                _resultArray = [NSMutableArray arrayWithArray:_array];
                break;
            }
        }
    }
    [self orderPicture];
   
//    NSLog(@"%@", _array);
    for (NSUInteger i = 0; i < _array.count; i++) {
        CGRect rect = CGRectFromString(_rectArray[i]);
        UIImageView *view = _array[i];
        view.frame = rect;
//        NSLog(@"%@", _rectArray[i]);
        [self addTap:view];
        [self.imageView addSubview:view];
    }
    
//    NSLog(@"%@", _array);
}
//添加滑动手势
- (void)addTap:(UIImageView *)imageView{

    UISwipeGestureRecognizerDirection dir[] = {
        
        UISwipeGestureRecognizerDirectionRight,
        UISwipeGestureRecognizerDirectionLeft,
        UISwipeGestureRecognizerDirectionUp,
        UISwipeGestureRecognizerDirectionDown,
    };
    for (NSUInteger i = 0; i < sizeof(dir) / sizeof(dir[0]); i++) {
        
        UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureHandle:)];
        sgr.direction = dir[i];
        [imageView addGestureRecognizer:sgr];
    }
}
//滑动手势分发
- (void)tapGestureHandle:(UISwipeGestureRecognizer *)sgr{

//    NSLog(@"1  %@", _array);
    CGPoint whiteCenter = _whiteView.center;
    CGPoint center;
    for (NSUInteger i = 10; i < 21; i++) {
        
        UIImageView *moveView = (UIImageView *)[self.imageView viewWithTag:i];
        CGPoint moveCenter = moveView.center;

        switch (sgr.direction) {
            case UISwipeGestureRecognizerDirectionDown:
            {
                
                if ((whiteCenter.y - moveCenter.y) == YMOVE_STEP + 2 && whiteCenter.x == moveCenter.x) {
                    
                    center = whiteCenter;
                    whiteCenter = moveCenter;
                    moveCenter = center;
                    _whiteView.center = whiteCenter;
                    moveView.center = moveCenter;
//                    [_array exchangeObjectAtIndex:i - 10 withObjectAtIndex:i - 7];
                    [self jugeResult];
                    return;
                }
            }
                break;
            case UISwipeGestureRecognizerDirectionUp:
            {
                if ((moveCenter.y - whiteCenter.y) == YMOVE_STEP + 2&& whiteCenter.x == moveCenter.x) {
                    
                    center = whiteCenter;
                    whiteCenter = moveCenter;
                    moveCenter = center;
                    _whiteView.center = whiteCenter;
                    moveView.center = moveCenter;
//                    [_array exchangeObjectAtIndex:i - 10 withObjectAtIndex:i + 3];
                    [self jugeResult];
                    return;
                }

            }
                break;
            case UISwipeGestureRecognizerDirectionLeft:
            {
                
                if ((int)(moveCenter.x - whiteCenter.x) == (int)(XMOVE_STEP + 2) && whiteCenter.y == moveCenter.y) {
                    
                    center = whiteCenter;
                    whiteCenter = moveCenter;
                    moveCenter = center;
                    _whiteView.center = whiteCenter;
                    moveView.center = moveCenter;
//                    [_array exchangeObjectAtIndex:i - 10 withObjectAtIndex:i - 11];
                    [self jugeResult];
                    return;
                }

            }
                break;
            case UISwipeGestureRecognizerDirectionRight:
            {
                if ((int)(whiteCenter.x - moveCenter.x) == (int)(XMOVE_STEP + 2) && whiteCenter.y == moveCenter.y) {
                    center = whiteCenter;
                    whiteCenter = moveCenter;
                    moveCenter = center;
                    _whiteView.center = whiteCenter;
                    moveView.center = moveCenter;
//                    [_array exchangeObjectAtIndex:i - 10 withObjectAtIndex:i - 9];
                    [self jugeResult];
                    return;
                }

            }
                break;
            
            default:
                break;
        }
    }
    
}

//- (void)changePicture:(CGPoint)center andWhiteCenter:(CGPoint)whiteCenter moveCenter:(CGPoint)moveCenter{
//
//    center = whiteCenter;
//    whiteCenter = moveCenter;
//    moveCenter = center;
//    _whiteView.center = whiteCenter;
//    moveView.center = moveCenter;
//    //                    [_array exchangeObjectAtIndex:i - 10 withObjectAtIndex:i - 9];
//    [self jugeResult];
//
//}
//打乱顺序
- (void)orderPicture{

    NSUInteger number = arc4random()%3;
    NSUInteger number1 = arc4random()%3 + 3;
    NSUInteger number3 = arc4random()%6 + 6;
    [_array exchangeObjectAtIndex:number withObjectAtIndex:number1];
    [_array exchangeObjectAtIndex:number1 withObjectAtIndex:number3];
}
//判断结果
- (void)jugeResult{

    for (UIImageView *image1 in _resultArray) {
        for (UIImageView *image2 in _array) {
            if (image1.tag != image2.tag) {
//                NSLog(@"%ld %ld", image1≥.tag, image2.tag);
                return;
            }
        }
    }
    NSLog(@"success");
    ResultViewController *rvc = [[ResultViewController alloc]init];
    [self.navigationController pushViewController:rvc animated:YES];
}
//创建时间条
- (void)createProgress{
    
    UIProgressView *pv = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    pv.frame = CGRectMake(50, 450, VIEW_WIDTH - 100, 10 );
    
    pv.trackTintColor = [UIColor colorWithRed:0.728 green:0.139 blue:0.066 alpha:1.000];
    pv.progressTintColor = [UIColor grayColor];
    pv.transform = CGAffineTransformMakeScale(1, 3);
    
    [self performSelector:@selector(changeProgress:) withObject:pv afterDelay:0.01];
    
    [self.view addSubview:pv];
}

- (void)changeProgress:(UIProgressView *)pv{

    CGFloat progress = pv.progress + 0.001;
    [pv setProgress:progress];
    if (progress >= 1.0) {
        int a = arc4random()%25 + 1;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"美女%.2d.jpg", a]];
        [self createMainScreen:image];
        [self orderPicture];
        [pv setProgress:0.0];
    }
    [self performSelector:@selector(changeProgress:) withObject:pv afterDelay:1.0];
}

@end







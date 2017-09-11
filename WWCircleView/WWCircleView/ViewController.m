//
//  ViewController.m
//  WWCircleView
//
//  Created by Carbon on 2017/9/8.
//  Copyright © 2017年 Carbon. All rights reserved.
//

#import "ViewController.h"
#import "WWCircleView.h"
@interface ViewController ()
<
WWCircleViewDelegate
>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *viewArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 20; i++) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        UIImageView *imV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imV.image = [UIImage imageNamed:@"doctorKang"];
        [v addSubview:imV];
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 50, 30)];
        l.font = [UIFont systemFontOfSize:13.0];
        l.textAlignment = NSTextAlignmentCenter;
        l.textColor = [UIColor orangeColor];
        l.text = @"大大白";
        [v addSubview:l];
        [viewArr addObject:v];
    }
    WWCircleView *wwView = [[WWCircleView alloc] initWithFrame:self.view.frame circleCenter:self.view.center contentsArray:viewArr];
    wwView.delegate = self;
    [self.view addSubview:wwView];
}

#pragma mark -- WWCircleViewDelegate
- (void)ww_circleView:(WWCircleView *)circleView didSelectedWithIndex:(NSInteger)index {
    NSLog(@"%ld",(long)index);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

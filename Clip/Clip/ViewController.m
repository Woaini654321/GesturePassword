//
//  ViewController.m
//  Clip
//
//  Created by 晏玉龙 on 2017/2/13.
//  Copyright © 2017年 晏玉龙. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.imageV addGestureRecognizer:pan];
}


- (void)pan:(UIGestureRecognizer *)pan{
    CGPoint curP = [pan locationInView:self.imageV];
    
    CGFloat rectWH = 30;
    CGFloat x = curP.x - rectWH * 0.5;
    CGFloat y = curP.y - rectWH * 0.5;
    CGRect rect = CGRectMake(x, y, rectWH, rectWH);
    
    UIGraphicsBeginImageContextWithOptions(self.imageV.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.imageV.layer renderInContext:ctx];
    
    CGContextClearRect(ctx, rect);
    
    UIImage *newInage = UIGraphicsGetImageFromCurrentImageContext();
    self.imageV.image = newInage;

}

@end

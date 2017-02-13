//
//  LockView.m
//  Clip
//
//  Created by Yan on 2017/2/13.
//  Copyright © 2017年 Yan. All rights reserved.
//

#import "LockView.h"
@interface LockView()
/** 存放的都是当前选中的按钮 */
@property (nonatomic, strong) NSMutableArray *selectBtnArray;
//当前手指所在的点
@property (nonatomic, assign) CGPoint curP;
@end
@implementation LockView

- (void)awakeFromNib{
    [self setUp];
}

- (NSMutableArray *)selectBtnArray{
    if (!_selectBtnArray) {
        _selectBtnArray = [NSMutableArray array];
        
    }
    return _selectBtnArray;
}

- (void)setUp{
    for (int i = 0; i < 9; i++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.userInteractionEnabled = NO;
        btn.tag = i;
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_node_selected"] forState:UIControlStateSelected];
        [self addSubview:btn];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat btnWH = 74;
    
    int column = 3;
    CGFloat margin = (self.bounds.size.width - btnWH * column)/(column + 1);
    
    int curC = 0;
    int curR = 0;
    
    for (int i = 0; i < self.subviews.count; i++) {
        curC = i % column;
        curR = i / column;
        
        x = margin + (btnWH + margin) * curC;
        y = margin + (btnWH + margin) * curR;
        
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(x, y, btnWH, btnWH);
    }
}

- (CGPoint)getCurrentPoint:(NSSet<UITouch *> *)touches{
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self];
}

- (UIButton *)btnRectContainsPoint:(CGPoint)point{
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point) && ![self.selectBtnArray containsObject:btn]) {
            return btn;
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint curP = [self getCurrentPoint:touches];
    UIButton *btn = [self btnRectContainsPoint:curP];
    if (btn) {
        btn.selected = YES;
        [self.selectBtnArray addObject:btn];
    }
}

//手指移动时调用
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint curP = [self getCurrentPoint:touches];
    self.curP = curP;
    UIButton *btn = [self btnRectContainsPoint:curP];
    if (btn) {
        btn.selected = YES;
        [self.selectBtnArray addObject:btn];
    }
    [self setNeedsDisplay];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self performSelector:@selector(removeAllOperation) withObject:nil afterDelay:1.0f];
}

- (void)removeAllOperation{
    NSMutableString *str = [NSMutableString string];
    for (UIButton *btn in self.selectBtnArray) {
        btn.selected = NO;
        [str appendFormat:@"%ld",btn.tag];
    }
    NSLog(@"手势密码为%@",str);
    [self.selectBtnArray removeAllObjects];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    if (self.selectBtnArray.count) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        for (int i = 0; i < self.selectBtnArray.count; i++) {
            UIButton *btn = self.selectBtnArray[i];
            if (i == 0) {
                [path moveToPoint:btn.center];
            }else{
                [path addLineToPoint:btn.center];
            }
            
        }
        [path addLineToPoint:self.curP];
        [path setLineWidth:10];
        [[UIColor redColor] set];
        [path setLineJoinStyle:kCGLineJoinRound];
        [path stroke];
    }
}
@end

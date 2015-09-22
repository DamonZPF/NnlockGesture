//
//  GestureView.m
//  NnlockGesture
//
//  Created by Duomai on 15/9/22.
//  Copyright © 2015年 zpf. All rights reserved.
//

#import "GestureView.h"

#define kColumn 3

@interface GestureView()

@property(nonatomic,strong)NSMutableArray * btnsArray;
@property(nonatomic,assign)CGPoint movePoint;


@end

@implementation GestureView
-(NSMutableArray*)btnsArray{

    if (_btnsArray == nil) {
        _btnsArray = [NSMutableArray array];
    }
    
    return _btnsArray;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self setupSubviews];
    }
    return self;
}

-(void)setupSubviews{

    for (NSInteger index = 0; index < 9; index++) {
        
        UIButton * btn = [[UIButton alloc] init];
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        [self addSubview:btn];
    }
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat btnW = 74.0;
    CGFloat btnH = 74.0;
    
    CGFloat btnX = 0.0;
    CGFloat btnY = 0.0;
    
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width - (btnW* kColumn))/(kColumn+1);
  
    for (NSInteger index = 0; index < self.subviews.count; index++) {
        UIButton * btn = (UIButton*)self.subviews[index];
        btn.tag = index;
        NSInteger col = index % kColumn;
        NSInteger row = index / kColumn;
        
        btnX = margin + (margin + btnW)* col;
        btnY = (margin + btnW)* row;
        
        btn.frame = CGRectMake(btnX, btnY, btnW,  btnH);
    }
    
}

-(CGPoint)pointWithTouch:(NSSet*)touches{
    UITouch * touch =  [touches anyObject];
    CGPoint  point =[touch locationInView:self];
    
    return point;
}

-(UIButton*)buttonWithPoint:(CGPoint)point{
    
    CGFloat wh = 30;
    
    for (UIButton * button in self.subviews) {
        CGFloat x = button.center.x - wh* 0.5;
        CGFloat y = button.center.y - wh * 0.5;
        button.frame = CGRectMake(x, y, wh, wh);
        if (CGRectContainsPoint(button.frame, point)) {
            return button;
        }
    }
    return nil;
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [self pointWithTouch:touches];
    UIButton * btn = [self buttonWithPoint:point];
    
    if (btn && !btn.selected) {
        btn.selected = YES;
        [self.btnsArray addObject:btn];
    }
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [self pointWithTouch:touches];
    UIButton * btn = [self buttonWithPoint:point];
    
    self.movePoint = point;
    if (btn && !btn.selected) {
        btn.selected = YES;
        [self.btnsArray addObject:btn];
    }
 
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSMutableString * tempString = [NSMutableString string];
    for (UIButton * btn in self.btnsArray) {
        [tempString appendString:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
    }
    
    NSLog(@"%@",tempString);
    
    for (UIButton * btn in self.subviews) {
        btn.selected = NO;
    }
    
    [self.btnsArray removeAllObjects];
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    if (!self.btnsArray.count) {
        return;
    }
    
  UIBezierPath * path =   [UIBezierPath bezierPath];
    for (NSInteger index = 0; index < self.btnsArray.count; index++) {
        UIButton * selectedBtn = self.btnsArray[index];
        if (index == 0) {
            [path moveToPoint:selectedBtn.center];
        }else{
            [path addLineToPoint:selectedBtn.center];
        }
    }
    
    [path addLineToPoint:self.movePoint];
    [[UIColor grayColor] set];
    [path setLineWidth:8];
    [path setLineJoinStyle:kCGLineJoinBevel];
    [path stroke];
}

@end

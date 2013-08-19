//
//  PointerView.m
//  Plotter
//
//  Created by Jon Guan on 8/19/13.
//  Copyright (c) 2013 Scanadu, Inc. All rights reserved.
//

#import "PointerView.h"

@implementation PointerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (_drawPointer)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGRect frame = self.frame;
        CGContextSetLineWidth(context, 2.0);
        CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.4 green:0.8 blue:0.4 alpha:1.0] CGColor]);
        CGContextMoveToPoint(context, _pointerX, 0);
        CGContextAddLineToPoint(context, _pointerX, frame.size.height);
        CGContextStrokePath(context);
    }
}


#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    _pointerX = point.x;
    _drawPointer = YES;
    [self setNeedsDisplay];
}

@end

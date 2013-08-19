//
//  PointerView.m
//  Plotter
//
//  Created by Jon Guan on 8/19/13.
//  Copyright (c) 2013 Scanadu, Inc. All rights reserved.
//

#import "PointerView.h"
#import "ViewConstants.h"

@implementation PointerView

static float data[] = {0.7, 0.4, 0.9, 1.0, 0.2, 0.85, 0.11, 0.75, 0.53, 0.44, 0.88, 0.77};

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
        CGContextMoveToPoint(context, _touchPoint.x, 0);
        CGContextAddLineToPoint(context, _touchPoint.x, frame.size.height);
        CGContextStrokePath(context);
        
        // Draw text
        
        // Calculate nearest point corresponding to touch
        int index = (int)roundf((_touchPoint.x-kOffsetX)/kStepX);
        CGContextSetTextDrawingMode(context, kCGTextFill);
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
        NSString *text = [NSString stringWithFormat:@"(%d, %0.1f)", kOffsetX + kStepX*index, kOffsetY + data[index]];
        NSLog(@"%@", text);
        [text drawAtPoint:CGPointMake(kOffsetX + kStepX*index, data[index] + kOffsetY) withAttributes:nil];
    }
}


#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _touchPoint = [touch locationInView:self];
    

    _drawPointer = YES;
    [self setNeedsDisplay];
}

@end

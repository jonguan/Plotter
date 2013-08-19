//
//  GraphView.m
//  Plotter
//
//  Created by Jon Guan on 8/19/13.
//  Copyright (c) 2013 Scanadu, Inc. All rights reserved.
//

#import "GraphView.h"
#import "ViewConstants.h"

@implementation GraphView

static float data[] = {0.7, 0.4, 0.9, 1.0, 0.2, 0.85, 0.11, 0.75, 0.53, 0.44, 0.88, 0.77};

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // White background
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSaveGState(context);
    // Grid
    CGContextSetLineWidth(context, 0.6);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGFloat dash[] = {5.0, 1.0, 3.0, 1.0, 1.0, 1.0};
    CGContextSetLineDash(context, 0.0, dash, 6);
    
    
    // Fill X and Y grid lines
    int numLinesX = (kDefaultGraphWidth - kOffsetX) / kStepX;
    
    for (int i = 0; i <= numLinesX; i++) {
        CGContextMoveToPoint(context, kOffsetX + i * kStepX, kGraphTop);
        CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphBottom);
    }
    
    int numLinesY = (kGraphBottom - kGraphTop - kOffsetY) / kStepY;
    for (int i = 0; i <= numLinesY; i++) {
        CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - i*kStepY);
        CGContextAddLineToPoint(context, kDefaultGraphWidth, kGraphBottom - kOffsetY - i*kStepY);
    }
    
    CGContextStrokePath(context);
    
    
    
    CGContextRestoreGState(context);
    
    [self drawLineGraphWithContext:context];
    
    // Draw x Labels
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    CGContextSetTextDrawingMode(context, kCGTextFill);
    

    for (int i = 1; i < sizeof(data); i++)
    {
        NSString *theText = [NSString stringWithFormat:@"%d", i];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],  NSStrokeColorAttributeName:[UIColor whiteColor]};
        CGSize labelSize = [theText sizeWithAttributes:attributes];
        [theText drawAtPoint:CGPointMake(kOffsetX + i*kStepX - (labelSize.width/2), kGraphBottom-20) withAttributes:attributes];
        
    }

}

- (void)drawLineGraphWithContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    
    // Draw the lines
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:1.0] CGColor]);
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:0.5] CGColor]);

    int maxGraphHeight = kGraphHeight - kOffsetY;
    // Line
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, kOffsetX, kGraphHeight - maxGraphHeight * data[0]);
    for (int i =1; i < sizeof(data); i++) {
        CGContextAddLineToPoint(ctx, kOffsetX + i*kStepX, kGraphHeight - maxGraphHeight * data[i]);
    }
    CGContextDrawPath(ctx, kCGPathStroke);
    
    // Fill
    /////////
    // Gradient
    CGFloat components[12] = {1.0, 0, 85/255, 1.0,  // red color
        0, 89/255, 1.0, 1.0, // blue color
        16/255, 255/255, 4/255, 1.0}; // green color
    CGFloat locations[3] = {0.0, 0.33, 1.0};
    size_t num_locations = 3;
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    CGPoint startPoint = CGPointMake(kOffsetX, kGraphHeight);
    CGPoint endPoint = CGPointMake(kOffsetX, kOffsetY);


    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, kOffsetX, kGraphHeight);
    CGContextAddLineToPoint(ctx, kOffsetX, kGraphHeight - maxGraphHeight * data[0]);
    for (int i = 1; i < sizeof(data); i++)
    {
        CGContextAddLineToPoint(ctx, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * data[i]);
    }
    CGContextAddLineToPoint(ctx, kOffsetX + (sizeof(data) - 1) * kStepX, kGraphHeight);
    CGContextClosePath(ctx);
//    CGContextDrawPath(ctx, kCGPathFill);
    
    CGContextSaveGState(ctx);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    
    // Release the resources
    CGColorSpaceRelease(colorspace);
    CGGradientRelease(gradient);
    
    
    
    // Add points
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:1.0] CGColor]);
    for (int i = 0; i < sizeof(data); i++) {
        float x = kOffsetX + i * kStepX;
        float y = kGraphHeight - maxGraphHeight * data[i];
        
        CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
        CGContextAddEllipseInRect(ctx, rect);
        
    }
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    CGContextRestoreGState(ctx);
}






@end

//
//  LineDrawingView.m
//  FirstBankApp
//
//  Created by [Your Name] on 22/07/2025.
//  Copyright © 2025 Gedu Technologies. All rights reserved.
//

#import "LineDrawingView.h"

@implementation LineDrawingView

// Initialize with default values
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Set a clear background so the line is visible on top of other content
        self.backgroundColor = [UIColor clearColor];
        // Set default line properties
        _lineColor = [UIColor redColor]; // Default red line
        _lineWidth = 2.0;               // Default 2-point thick line
    }
    return self;
}

// This method is called by the system when the view needs to be drawn or redrawn.
// All custom drawing code should go here.
- (void)drawRect:(CGRect)rect {
    // IMPORTANT FIX: Add a check to ensure the rect has valid, non-zero dimensions
    // This prevents CoreGraphics errors if the view's frame is invalid during initial layout.
    if (CGRectIsEmpty(rect) || isnan(rect.origin.x) || isnan(rect.origin.y) || isnan(rect.size.width) || isnan(rect.size.height)) {
        NSLog(@"LineDrawingView: drawRect called with invalid rect: %@", NSStringFromCGRect(rect));
        return; // Do not draw if rect is invalid
    }

    // Get the current graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Set the stroke color (color of the line)
    [self.lineColor setStroke];

    // Set the line width
    CGContextSetLineWidth(context, self.lineWidth);

    // Define the starting point of the line (from left edge of the view)
    CGPoint startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
    // Define the ending point of the line (to right edge of the view)
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));

    // Move to the starting point
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    // Add a line to the ending point
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);

    // Draw the line
    CGContextStrokePath(context);
}

// If you change lineColor or lineWidth, you need to tell the view to redraw itself.
- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self setNeedsDisplay]; // Marks the view as needing to be redrawn
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self setNeedsDisplay]; // Marks the view as needing to be redrawn
}

@end


//
//  DemoView.m
//  CoreGraphicsDemo
//
//  Created by leihui on 13-12-18.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "DemoView.h"

@implementation DemoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRoofTopAtTopPointOf:(CGPoint)paramTopPoint textToDisplay:(NSString *)text lineJoin:(CGLineJoin)lineJoin
{
    [[UIColor brownColor] set];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineJoin(context, lineJoin);
    CGContextSetLineWidth(context, 20.0f);
    CGContextMoveToPoint(context, paramTopPoint.x-140, paramTopPoint.y+100);
    CGContextAddLineToPoint(context, paramTopPoint.x, paramTopPoint.y);
    CGContextAddLineToPoint(context, paramTopPoint.x+140, paramTopPoint.y+100);
    CGContextStrokePath(context);
    
    [[UIColor brownColor] set];
    
    [text drawAtPoint:CGPointMake(paramTopPoint.x-40.0f, paramTopPoint.y+60.0f) withFont:[UIFont boldSystemFontOfSize:30.0f]];
}

- (void)drawRectAtTopOfScreen
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);//保存图形上下文的状态
    CGContextSetShadowWithColor(currentContext, CGSizeMake(10.0f, 10.0f)/*偏移量*/, 20.0f/*模糊度*/, [[UIColor grayColor] CGColor]);
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGRect rect = CGRectMake(55.0f, 200.0f, 100.0f, 100.0f);
    CGPathAddRect(path, NULL, rect);
    CGContextAddPath(currentContext, path);
    [[UIColor colorWithRed:0.20f green:0.60f blue:0.80f alpha:1.0f] setFill];
    CGContextDrawPath(currentContext, kCGPathFill);
    
    CGPathRelease(path);
    CGContextRestoreGState(currentContext); //恢复到以前的状态
}

- (void)drawRectAtBottomOfScreen
{
    /* Get the handle to the current context */
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect rect = CGRectMake(50.0f, 250.0f, 200.0f, 200.0f);
    CGPathAddRect(path, NULL, rect);
    CGContextAddPath(currentContext, path);
    [[UIColor purpleColor] setFill];
    CGContextDrawPath(currentContext, kCGPathFill);
    CGPathRelease(path);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIColor *color = [UIColor colorWithRed:0.0 green:0.0f blue:1.0f alpha:1.0f];
    [color set];
    
#if 0
    /**
     *  Draw text
     */
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40.0f];
    NSString *text = @"Some String";
    [text drawAtPoint:CGPointMake(10, 10) withFont:font];
#endif
    
    /**
     *  Color reference
     */
    CGColorRef colorRef =[color CGColor];   //CGColorRef 的对象
    const CGFloat *components = CGColorGetComponents(colorRef); //颜色对象的各个分量
    NSUInteger componentsCount = CGColorGetNumberOfComponents(colorRef); //颜色对象的各个分量的数量
    
    NSUInteger counter = 0;
    for (counter = 0; counter < componentsCount; counter++) {
        NSLog(@"compoent %lu = %0.02f",(unsigned long )counter+1, components[counter]);
    }
    
#if 0
    /**
     *  Draw image
     */
    UIImage *image = [UIImage imageNamed:@"image.png"];
    if (image != nil) {
        [image drawAtPoint:CGPointMake(0, 100)];
    }
    else {
        NSLog(@"Failed to load the image...");
    }
#endif
    
#if 0
    /**
     *  Draw line
     */
    [[UIColor brownColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 5.f);
    CGContextMoveToPoint(context, 20.f, 20.f);
    CGContextAddLineToPoint(context, 100.f, 100.f);
    CGContextAddLineToPoint(context, 300.f, 100.f);
    CGContextStrokePath(context);
#endif
    
#if 0
    /**
     *  Line join
     */
    [self drawRoofTopAtTopPointOf:CGPointMake(160.0f, 40.0f)
                    textToDisplay:@"尖角连接"
                         lineJoin:kCGLineJoinMiter];    //尖角连接
    
    [self drawRoofTopAtTopPointOf:CGPointMake(160.0f, 180.0f)
                    textToDisplay:@"平角"
                         lineJoin:kCGLineJoinBevel];    //平角
    
    [self drawRoofTopAtTopPointOf:CGPointMake(160.0f, 320.0f)
                    textToDisplay:@"圆形"
                         lineJoin:kCGLineJoinRound];    // 圆形
#endif
    
#if 0
    /**
     *  Draw path
     */
    [[UIColor blueColor] setStroke];
    CGContextSetLineWidth(context, 4.0f);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y);
    CGPathAddLineToPoint(path, NULL, rect.size.width, rect.size.height);
    CGPathMoveToPoint(path, NULL, rect.size.width, rect.origin.y);
    CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.size.height);
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGPathRelease(path);
#endif
    
#if 0
    /**
     *  Draw rectangle
     */
    CGMutablePathRef path1 = CGPathCreateMutable();//Create the path first. Just the path handle
    CGRect rectangle = CGRectMake(10, 10, 200, 200);
    CGPathAddRect(path1, NULL, rectangle);//Add the rectangle to the path1
    
    CGContextAddPath(context, path1);// Add the path to the context
    [[UIColor blueColor] setFill];//Set the fill color to blue
    [[UIColor brownColor] setStroke];// Set the stroke color to brown
    CGContextSetLineWidth(context, 5.0f);
    CGContextDrawPath(context, kCGPathFillStroke);//Stroke and fill the path on the context
    
    CGPathRelease(path1);
#endif
    
#if 0
    /**
     *  Draw rectangles
     */
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGRect rectangle1 =  CGRectMake(30, 30, 20, 30);
    CGRect rectangle2 =  CGRectMake(40, 10, 90, 50);
    CGRect rectangles[2] = {rectangle1, rectangle2};
    CGPathAddRects(path2, NULL, (const CGRect *)&rectangles, 2);
    
    CGContextAddPath(context, path2);
    [[UIColor colorWithRed:0.20f green:0.60f blue:0.80f alpha:1.0f] setFill];
    [[UIColor blackColor] setStroke];
    CGContextSetLineWidth(context, 3);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGPathRelease(path2);
#endif
    
#if 0
    /**
     *  Add Shape Shadow
     */
    [self drawRectAtTopOfScreen];
    [self drawRectAtBottomOfScreen];
#endif
    
#if 0
    /**
     *  绘制线性渐的（Axial轴向）变颜色
     */
    CGContextRef currentContext_1 = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext_1);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();//给一个ＲＧＢ色彩空间
    
    UIColor *startColor = [UIColor orangeColor];
    CGFloat *startColorComponents = (CGFloat *)CGColorGetComponents([startColor CGColor]);
    
    UIColor *endColor = [UIColor blueColor];
    CGFloat *endColorComponents = (CGFloat *)CGColorGetComponents([endColor CGColor]);
    
    //颜色分量
    CGFloat colorComponents[8] =
    {
        startColorComponents[0],/* Four components of the orange color (RGBA) */
        startColorComponents[1],
        startColorComponents[2],
        startColorComponents[3], /* First color = orange */
        
        endColorComponents[0],/* Four components of the blue color (RGBA) */
        endColorComponents[1],
        endColorComponents[2],
        endColorComponents[3], /* Second color = blue */
    };
    CGFloat colorIndices[2] = //颜色数组中各个颜色的位置，一种颜色到另一种颜色的变速有多快。必须和CGGradientCreateWithColorComponents的第四个参数个数相同
    {
        0.0f, /* Color 0 in the colorComponents array */
        1.0f, /* Color 1 in the colorComponents array */
    };
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, (const CGFloat *)&colorComponents, (const CGFloat *)&colorIndices, 2);//创建渐变对象句柄
    CGColorSpaceRelease(colorSpace);
    
    CGPoint startPoint, endPoint;
    startPoint = CGPointMake(120, 260);
    endPoint = CGPointMake(200, 220);
//    CGContextDrawLinearGradient (currentContext_1, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextDrawLinearGradient(currentContext_1, gradient, startPoint, endPoint, 0);//0为不扩展渐变
    CGGradientRelease(gradient);
    CGContextRestoreGState(currentContext_1);
#endif
    
#if 0
    /**
     *  CGAffineTransformMakeTranslate 仿射变换
     */
    CGMutablePathRef pathA = CGPathCreateMutable();/* Create the pathA first. Just the path handle. */
    CGRect rectangleA = CGRectMake(10.0f, 10.0f, 100.0f, 90.0f);
    
    // 沿x方向移150
    CGAffineTransform transform = CGAffineTransformMakeTranslation(150.0f, 0.0f);
    CGPathAddRect(pathA, &transform, rectangleA);/* Add the rectangleA to the path */
    
    CGContextRef currentContextB = UIGraphicsGetCurrentContext();
    CGContextAddPath(currentContextB, pathA);
    
    [[UIColor colorWithRed:0.20f green:0.60f blue:0.80f alpha:1.0f] setFill];
    [[UIColor brownColor] setStroke];/* Set the stroke color to brown */
    
    CGContextSetLineWidth(currentContextB, 4.0f);
    CGContextDrawPath(currentContextB, kCGPathFillStroke);/* Stroke and fill the path on the context */
    CGPathRelease(pathA);
    
#endif
    
#if 0
    /**
     *  CGContextTranslateCTM (CTM current transformation matrix 当前变换矩阵）
     */
    CGMutablePathRef pathCTM = CGPathCreateMutable();
    CGRect rectangleCTM = CGRectMake(200, 10, 50, 100);
    CGPathAddRect(pathCTM, NULL, rectangleCTM);
    CGContextRef currentContextCTM = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContextCTM);
    CGContextTranslateCTM(currentContextCTM, .0f, 100.0f);/* Translate the current transformation matrix to the right by 100 points */
    CGContextAddPath(currentContextCTM, pathCTM);/* Add the path to the context */
    [[UIColor colorWithRed:0.20f green:0.60f blue:0.80f alpha:1.0f] setFill];
    [[UIColor brownColor] setStroke];
    CGContextSetLineWidth(currentContextCTM, 5.0f);
    CGContextDrawPath(currentContextCTM, kCGPathFillStroke);
    CGPathRelease(pathCTM);
    CGContextRestoreGState(currentContextCTM);
#endif
    
#if 0
    /**
     *  CGAffineTransformMakeScale 缩放图形
     */
    CGMutablePathRef pathMC = CGPathCreateMutable();
    CGRect rectangleMC = CGRectMake(10.0f, 300.0f, 200.0f, 300.0f);/* Here are our rectangle boundaries */
    CGPathAddRect(pathMC, NULL, rectangleMC); /* Add the rectangle to the path */
    CGContextRef currentContextMC = UIGraphicsGetCurrentContext();/* Get the handle to the current context */
    CGContextScaleCTM(currentContextMC, 0.5f, 0.5f); /* Scale everything drawn on the current graphics context to half itssize */
    
    CGContextAddPath(currentContextMC, pathMC); /* Add the path to the context */
    [[UIColor colorWithRed:0.20f green:0.60f blue:0.80 alpha:1.0f] setFill];  /* Set the fill color to cornflower blue */
    [[UIColor brownColor] setStroke];/* Set the stroke color to brown */
    CGContextSetLineWidth(currentContextMC, 5.0f);  /* Set the line width (for the stroke) to 5 */
    CGContextDrawPath(currentContextMC, kCGPathFillStroke);  /* Stroke and fill the path on the context */
    CGPathRelease(pathMC);  /* Dispose of the path */
#endif
    
#if 0
    /**
     *  CGAffineTransformMakeRotation 旋转图形 旋转值必为弧度度，正值代表顺时针旋转，负值代表逆时针旋转
     */
    CGMutablePathRef pathMR = CGPathCreateMutable();
    CGAffineTransform transformMR = CGAffineTransformMakeRotation((45.0f * M_PI) / 180.0f);
    CGRect rectangleMR = CGRectMake(200, 50, 50, 100);
    CGPathAddRect(pathMR, &transformMR, rectangleMR);
    CGContextRef currentContextMR = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContextMR);
    CGContextTranslateCTM(currentContextMR, .0f, 100.0f);
    CGContextAddPath(currentContextMR, pathMR);/* Add the path to the context */
    [[UIColor colorWithRed:0.20f green:0.60f blue:0.80f alpha:1.0f] setFill];
    [[UIColor brownColor] setStroke];
    CGContextSetLineWidth(currentContextMR, 5.0f);
    CGContextDrawPath(currentContextMR, kCGPathFillStroke);
    CGPathRelease(pathMR);
    CGContextRestoreGState(currentContextMR);
#endif
    
    /**
     *  Draw bezier
     */
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(20, 20)];
    [bezierPath addCurveToPoint:CGPointMake(220, 220) controlPoint1:CGPointMake(120, 50) controlPoint2:CGPointMake(200, 70)];
    CGContextAddPath(context, bezierPath.CGPath);
    [bezierPath stroke];
}

#pragma mark - dealloc

- (void)dealloc
{
    [super dealloc];
}

@end

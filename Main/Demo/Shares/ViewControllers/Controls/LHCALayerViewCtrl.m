//
//  LHCALayerViewCtrl.m
//  Demo
//
//  Created by leihui on 13-7-31.
//
//

#import "LHCALayerViewCtrl.h"

void MyDrawColoredPattern (void *info, CGContextRef context);

static inline double radians (double degrees) 
{ 
    return degrees * M_PI/180; 
}

void MyDrawColoredPattern (void *info, CGContextRef context)
{
    CGColorRef dotColor = [UIColor colorWithHue:0 saturation:0 brightness:0.07 alpha:1.0].CGColor;
    CGColorRef shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1].CGColor;
    
    CGContextSetFillColorWithColor(context, dotColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 1, shadowColor);
    
    CGContextAddArc(context, 3, 3, 4, 0, radians(360), 0);
    CGContextFillPath(context);
    
    CGContextAddArc(context, 16, 16, 4, 0, radians(360), 0);
    CGContextFillPath(context);
}

@interface LHCALayerViewCtrl ()

@end

@implementation LHCALayerViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, APP_VIEW_HEIGH)];
    self.view = view;
    [view release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIView *view = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
    [self.view addSubview:view];
    
    view.layer.backgroundColor = [UIColor orangeColor].CGColor;
    view.layer.cornerRadius = 20.0;
    view.layer.frame = CGRectInset(self.view.layer.frame, 20, 20);
    
    // Sub layer
    CALayer *subLayer = [CALayer layer];
    subLayer.backgroundColor = [UIColor blueColor].CGColor;
    subLayer.shadowOffset = CGSizeMake(0, 3);
    subLayer.shadowRadius = 5.0;
    subLayer.shadowColor = [UIColor blackColor].CGColor;
    subLayer.shadowOpacity = 0.8;
    subLayer.frame = CGRectMake(10, 30, 128, 192);
    subLayer.borderColor = [UIColor blackColor].CGColor;
    subLayer.borderWidth = 2.0;
    subLayer.cornerRadius = 10.0;
    [view.layer addSublayer:subLayer];
    
    // Image layer
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = subLayer.bounds;
    imageLayer.cornerRadius = 10.0;
    imageLayer.contents = (id)[UIImage imageNamed:@"test01.png"].CGImage;
    imageLayer.masksToBounds = YES;
    [subLayer addSublayer:imageLayer];
    
    // Custom draw
    _customDraw = [[CALayer layer] retain];
    _customDraw.delegate = self;
    _customDraw.backgroundColor = [UIColor greenColor].CGColor;
    _customDraw.frame = CGRectMake(10, 250, 128, 40);
    _customDraw.shadowOffset = CGSizeMake(0, 3);
    _customDraw.shadowRadius = 5.0;
    _customDraw.shadowColor = [UIColor blackColor].CGColor;
    _customDraw.shadowOpacity = 0.8;
    _customDraw.cornerRadius = 10.0;
    _customDraw.borderColor = [UIColor blackColor].CGColor;
    _customDraw.borderWidth = 2.0;
    _customDraw.masksToBounds = YES;
    [view.layer addSublayer:_customDraw];
    [_customDraw setNeedsDisplay];
    
    // Layer
    _layer = [[CALayer layer] retain];
    _layer.frame = CGRectMake(150, 30, 100, 100);
    _layer.backgroundColor = [UIColor yellowColor].CGColor;
    _layer.delegate = self;
    _layer.cornerRadius = 15.0;
    _layer.borderColor = [UIColor blackColor].CGColor;
    _layer.borderWidth = 5.0;
    [view.layer addSublayer:_layer];
    [_layer setNeedsDisplay];
    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    [animation setDuration:1.0];
//    [animation setRepeatCount:INT_MAX];
//    [animation setFromValue:[NSNumber numberWithFloat:0.0]];
//    [animation setToValue:[NSNumber numberWithFloat:1.0]];
//    [_layer addAnimation:animation forKey:nil];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [animation setDuration:2.0];
    [animation setRepeatCount:INT_MAX];
    [animation setFromValue:[NSNumber numberWithFloat:0.0]];
    [animation setToValue:[NSNumber numberWithFloat:M_PI * 2.0]];
    [_layer addAnimation:animation forKey:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CALayerDelegate

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
    if (layer == _customDraw) {
        CGColorRef bgColor = [UIColor colorWithHue:0.6 saturation:1.0 brightness:1.0 alpha:1.0].CGColor;
        CGContextSetFillColorWithColor(context, bgColor);
        CGContextFillRect(context, layer.bounds);
        
        static const CGPatternCallbacks callbacks = { 0, &MyDrawColoredPattern, NULL };
        
        CGContextSaveGState(context);
        CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
        CGContextSetFillColorSpace(context, patternSpace);
        CGColorSpaceRelease(patternSpace);
        
        CGPatternRef pattern = CGPatternCreate(NULL,
                                               layer.bounds,
                                               CGAffineTransformIdentity,
                                               24,
                                               24,
                                               kCGPatternTilingConstantSpacing,
                                               true,
                                               &callbacks);
        CGFloat alpha = 1.0;
        CGContextSetFillPattern(context, pattern, &alpha);
        CGPatternRelease(pattern);
        CGContextFillRect(context, layer.bounds);
        CGContextRestoreGState(context);
    }
    else {
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextSetLineWidth(context, 5.0);
        
        CGContextMoveToPoint(context, 5, 5);
        CGContextAddLineToPoint(context, 95, 95);
        
        CGContextStrokePath(context);
    }
}

#pragma mark - dealloc

- (void)dealloc
{
    if (_customDraw) {
        _customDraw.delegate = nil;
        [_customDraw release];
    }
    
    if (_layer) {
        _layer.delegate = nil;
        [_layer removeAllAnimations];
        [_layer release];
    }
    
    [super dealloc];
}

@end

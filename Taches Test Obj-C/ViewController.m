//
//  ViewController.m
//  Taches Test Obj-C
//
//  Created by Gevorg Hovhannisyan on 19.02.22.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) UIView* draggingView;
@property (assign, nonatomic) CGPoint touchoffset;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (int i = 0; i < 8; i++) {
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(10 + 110* i, 100, 100, 100)];
        view.backgroundColor = [self randomColor];
        
        [self.view addSubview:view];

        
    }
    
    //self.view.multipleTouchEnabled = YES;
    
}

- (void)didReceiveMemoryWarning
{
    
    [self didReceiveMemoryWarning];
    
}

#pragma Mark - Private Methods
- (void) logTouches:(NSSet*)touches withMethod:(NSString*) methodName {
    
    NSMutableString* string = [NSMutableString stringWithString:methodName];
    
    for (UITouch* touch in touches) {
        CGPoint point = [touch locationInView:self.view];
        [string appendFormat:@" %@", NSStringFromCGPoint(point)];
    }
    
    NSLog(@" %@", string);
}
- (UIColor*) randomColor {
    
    CGFloat r = (float) (arc4random() % 256) / 255;
    CGFloat g = (float) (arc4random() % 256) / 255;
    CGFloat b = (float) (arc4random() % 256) / 255;
    
    return [UIColor colorWithRed:r green:g blue:b alpha: 1.f];

}


#pragma Mark - Touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event; {
    
    [self logTouches:touches withMethod: @"touchesBegan"];
    UITouch* touch = [touches anyObject];
    CGPoint pointOnMainView = [touch locationInView:self.view];
    UIView* view = [self.view hitTest:pointOnMainView withEvent:event];
    
    if (![view isEqual:self.view]) {
        
        self.draggingView = view;
        
        CGPoint touchPoint = [touch locationInView:self.draggingView];
        
        self.touchoffset = CGPointMake(CGRectGetMidX(self.draggingView.bounds) - touchPoint.x,
                                       CGRectGetMidY(self.draggingView.bounds) - touchPoint.y);
        
        //Delete All Animations
        //[self.draggingView.layer removeAllAnimations];
    
    } else {
        
        self.draggingView = nil;
    }
    
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event; {
    
    [self logTouches:touches withMethod: @"touchesMoved"];
    
    if (self.draggingView) {
        
        UITouch* touch = [touches anyObject];
        
        CGPoint pointOnMainView = [touch locationInView:self.view];
        
        CGPoint correction = CGPointMake(pointOnMainView.x + self.touchoffset.x,
                                         pointOnMainView.y + self.touchoffset.y);
        
        self.draggingView.center = correction;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event; {
    
    [self logTouches:touches withMethod: @"touchesEnded"];
    
    self.draggingView = nil;

}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event; {
    
    [self logTouches:touches withMethod: @"touchesCancelled"];
    
    self.draggingView = nil;

}

@end

//
//  EPFMSliderView.m
//  EPFMSliderView
//
//  Created by enoughpower on 16/3/15.
//  Copyright © 2016年 enoughpower. All rights reserved.
//
#import "EPFMSliderView.h"
#define LongLine 14
#define ShortLine 9
#define LineNumber 120
#define LineCount 6
#define FontLineColor [UIColor colorWithRed:72/255.0 green:96/255.0 blue:109/255.0 alpha:1]
#define BackColor [UIColor colorWithRed:242/255.0 green:245/255.0 blue:249/255.0 alpha:1]

#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )
@interface EPFMSliderView ()
@property (nonatomic,assign)CGFloat centerX;
@property (nonatomic, assign)CGFloat centerY;
@property (nonatomic, assign)CGFloat radius;
@property (nonatomic, assign)CGFloat lineWidth;
@property (nonatomic, assign)CGFloat angle;
@property (nonatomic, assign)CGFloat labelHeight;
@property (nonatomic, strong)UILabel *titleLabel;


@end


@implementation EPFMSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.backgroundColor = [UIColor clearColor];
    _angle = 90;
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _titleLabel.textColor = FontLineColor;
    _titleLabel.font = [UIFont systemFontOfSize:30.f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _centerX = self.bounds.size.width /2;
    _centerY = self.bounds.size.height / 2;
    _radius = self.bounds.size.width >= self.bounds.size.height ? self.bounds.size.height/2 :self.bounds.size.width/2;
    _lineWidth = 1.f;
    _labelHeight = _radius *2/9;
    _titleLabel.frame = CGRectMake(0, 0, (_radius-LongLine-18)*2, 40);
    _titleLabel.center = CGPointMake(_centerX, _centerY);
    
    
}

- (void)showLabel
{
    if (_MaxNumber == 0) {
        _MaxNumber = 100;
    }
    if (_MinNumber == 0) {
        _MinNumber = 0;
    }
    CGFloat value = (_MaxNumber - _MinNumber)*_progress + _MinNumber;
    self.titleLabel.text = [NSString stringWithFormat:@"%.1fFM",value];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:_titleLabel.text];
    NSRange range = [_titleLabel.text rangeOfString:@"FM"];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.f] range:range];
    _titleLabel.attributedText = attribute;
    _value = floor(value *10);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetStrokeColorWithColor(ctx, FontLineColor.CGColor);
    for (int i = 0; i < LineNumber; i ++) {
        CGFloat progressX, progressY;
        if (i%LineCount!=0) {
            progressX = _centerX + cos(0 + 2*M_PI*i/LineNumber)*(self.radius-ShortLine);
            progressY = _centerY + sin(0 + 2*M_PI*i/LineNumber)*(self.radius-ShortLine);
        }else{
            progressX = _centerX + cos(0 +  2*M_PI*i/LineNumber)*(self.radius-LongLine);
            progressY = _centerY + sin(0 +  2*M_PI*i/LineNumber)*(self.radius-LongLine);
        }
        CGContextMoveToPoint(ctx, progressX, progressY);
        CGFloat x = _centerX + cos(0 + 2*M_PI*i/LineNumber)*self.radius;
        CGFloat y = _centerY + sin(0 + 2*M_PI*i/LineNumber)*self.radius;
        CGContextAddLineToPoint(ctx, x, y);
        CGContextDrawPath(ctx, kCGPathStroke);
    }
    CGContextAddArc(ctx, _centerX, _centerX, _radius-LongLine-6, 0, M_PI*2, 0);
    CGContextSetFillColorWithColor(ctx, BackColor.CGColor);
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), self.radius/20, [UIColor lightGrayColor].CGColor);
    CGContextDrawPath(ctx, kCGPathFill);
    [self drawTheHandle:ctx];
    [self showLabel];
}

-(void) drawTheHandle:(CGContextRef)ctx{
    
    CGContextSaveGState(ctx);
    
    //I Love shadows
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 3, [UIColor blackColor].CGColor);
    
    //Get the handle position!
    CGPoint handleCenter =  [self pointFromAngle:self.angle];
    CGContextDrawImage(ctx, CGRectMake(handleCenter.x-19/2, handleCenter.y-19/2, 19, 19), [UIImage imageNamed:@"btn_music_fm_piont"].CGImage);
    CGContextRestoreGState(ctx);
}

-(CGPoint)pointFromAngle:(int)angleInt{
    CGPoint result;
    result.y = round(_centerY + (_radius-LongLine-18) *sin(ToRad(-angleInt)));
    result.x = round(_centerX + (_radius-LongLine-18) *cos(ToRad(-angleInt)));
    return result;
}

/** Tracking is started **/
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    //We need to track continuously
    return YES;
}

/** Track continuos touch event (like drag) **/
-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    //Get touch location
    CGPoint lastPoint = [touch locationInView:self];
    
    //Use the location to design the Handle
    [self movehandle:lastPoint];
    
    //Control value has changed, let's notify that
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

/** Track is finished **/
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
}

- (void)movehandle:(CGPoint)lastPoint{
    
    //Get the center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2,
                                      self.frame.size.height/2);
    
    //Calculate the direction from the center point to an arbitrary position.
    float currentAngle = AngleFromNorth(centerPoint,
                                        lastPoint,
                                        NO);
    int angleInt = floor(currentAngle);
    
    //Store the new angle
    self.angle = 360 - angleInt;
    _progress = self.angle-90 < 0 ? (CGFloat)(360 + self.angle - 90) / (CGFloat)360 : (CGFloat)(self.angle - 90) / (CGFloat)360;
    //Update the textfield
    //Redraw
    [self setNeedsDisplay];
}

static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    self.angle = _progress*360+90 > 360 ? _progress*360+90-360 : _progress*360+90;
    [self setNeedsDisplay];
}







@end

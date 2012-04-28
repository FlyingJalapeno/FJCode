//
//  UIView-Extensions.m
//  Compounds
//
//  Created by Corey Floyd on 3/15/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import "UIView-Extensions.h"
#import "Functions.h"

@implementation UIView (utility)

- (void)setBackgroundColor:(UIColor*)aColor recursive:(BOOL)flag{
    
    self.backgroundColor = aColor;
	
    if(flag){
        for(UIView* eachSubview in self.subviews){
            [eachSubview setBackgroundColor:aColor recursive:YES];
            
        }
    }
}

@end


@implementation UIView (frame)

- (CGPoint)origin{
    
    return [self frame].origin;
}

-(void)setOrigin:(CGPoint)aPoint{
    
    CGRect newFrame = self.frame;
    newFrame.origin = aPoint;
    self.frame = newFrame;
    
}

- (CGFloat)x {
	return [self frame].origin.x;
}

- (void)setX:(CGFloat)x {
	CGRect rect = [self frame];
	rect.origin.x = x;
	[self setFrame:rect];
}

- (CGFloat)y {
	return [self frame].origin.y;
}

- (void)setY:(CGFloat)y {
	CGRect rect = [self frame];
	rect.origin.y = y;
	[self setFrame:rect];
}

- (CGSize)size {
	return [self frame].size;
}

- (void)setSize:(CGSize)size {
	CGRect rect = [self frame];
	rect.size = size;
	[self setFrame:rect];
}

- (CGFloat)width {
	return [self frame].size.width;
}

- (void)setWidth:(CGFloat)width {
	CGRect rect = [self frame];
	rect.size.width = width;
	[self setFrame:rect];
}

- (CGFloat)height {
	return [self frame].size.height;
}

- (void)setHeight:(CGFloat)height {
	CGRect rect = [self frame];
	rect.size.height = height;
	[self setFrame:rect];
}

- (CGPoint)centerOfBounds{
    
    return centerOfRect(self.bounds);
}


- (CGPoint)pointByAdjustingBoundsCenterByOffset:(CGPoint)offset{
    
    CGPoint p = centerOfRect(self.bounds);
    p.x += offset.x;
    p.y += offset.y;
    
    return p;

    
}

- (CGPoint)pointByAdjustingFrameCenterByOffset:(CGPoint)offset{
    
    CGPoint p = self.center;
    p.x += offset.x;
    p.y += offset.y;
    
    return p;
}

@end




@implementation UIView (points)

-(CGPoint)bottomCenter{
    
    return CGPointMake(self.frame.size.width/2, self.frame.size.height + self.frame.origin.y); 
}
-(CGPoint)topCenter{
    
    return CGPointMake(self.frame.size.width/2, self.frame.origin.y); 
}
-(CGPoint)leftCenter{
    
    return CGPointMake(self.frame.origin.x, self.frame.size.height/2); 
}
-(CGPoint)rightCenter{
    
    return CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.size.height/2); 
}
-(CGPoint)topRightCorner{
    
    return CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y); 
}
-(CGPoint)topLeftCorner{
        
    return CGPointMake(self.frame.origin.x, self.frame.origin.y); 
}
-(CGPoint)bottomLeftCorner{
    
    return CGPointMake(self.frame.origin.x, self.frame.size.height + self.frame.origin.y); 
}
-(CGPoint)bottomRightCorner{
    
    return CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.size.height + self.frame.origin.y); 
}



@end



@implementation UIView (introspection)

- (BOOL)hasSubviewOfClass:(Class)aClass{
    
    BOOL containsClass = NO;
    for(UIView *aSubview in self.subviews){
        NSLog(@"%@",[[aSubview class] description]);
        if([aSubview isKindOfClass:aClass]){
            containsClass = YES;
            break;
        } else {
            containsClass = [aSubview hasSubviewOfClass:aClass];
            if(containsClass)
                break;
        }
    }
    return containsClass;
}

- (BOOL)hasSubviewOfClass:(Class)aClass thatContainsPoint:(CGPoint)aPoint{
    
    BOOL touchIsInClass = NO;
    
    for(UIView *subview in self.subviews){
        
        CGPoint convertedPoint = [subview convertPoint:aPoint fromView:[self superview]];
        NSLog(@"%@",[[subview class] description]);
        if(CGRectContainsPoint(subview.frame, convertedPoint)){
            if([subview isKindOfClass:aClass]){
                touchIsInClass = YES;
                break;
            } else {
                touchIsInClass = [subview hasSubviewOfClass:aClass thatContainsPoint:convertedPoint];
                if(touchIsInClass)
                    break;
                
            }
        }
    }
    
    return touchIsInClass;
}


- (UIView*)firstResponder{
    
    UIView *theFirstResponder = nil;
    
    for(UIView *aSubview in self.subviews){
        
        if([aSubview isFirstResponder]){
            theFirstResponder = aSubview;
            break;
        } else{
            if((theFirstResponder = [aSubview firstResponder]))
                break;
        }
    }
    
    //if(!theFirstResponder)
    //NSLog(@"responder not found");
    return theFirstResponder;
    
}


@end


static const CGFloat kCornerSize = 5.0;

static CGRect rectStrokeAdjust(CGRect rect)
{
    rect = CGRectIntegral(rect);
    
    rect.origin.x    += 0.5;
    rect.origin.y    += 0.5;
    rect.size.width  -= 1.0;
    rect.size.height -= 1.0;
    
    return rect;
}

static void roundRect(CGContextRef context, CGRect rect,
                      CGFloat ovalWidth, CGFloat ovalHeight)
{
    CGFloat  fw = 0.0;
    CGFloat  fh = 0.0;
    
    assert(ovalWidth  >= 1.0);
    assert(ovalHeight >= 1.0);
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight); 
    
    fw = rect.size.width  / ovalWidth;
    fh = rect.size.height / ovalHeight; 
    
    CGContextMoveToPoint(context, fw, fh / 2.0);
    CGContextAddArcToPoint(context, fw, fh, fw / 2.0, fh, 1.0);
    CGContextAddArcToPoint(context, 0.0, fh, 0, fh / 2.0, 1.0);
    CGContextAddArcToPoint(context, 0.0, 0.0, fw / 2.0, 0, 1.0);
    CGContextAddArcToPoint(context, fw, 0.0, fw, fh / 2.0, 1.0); 
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}


@implementation UIView (drawing)


-(void)contextRestore:(CGContextRef)context
{
    CGContextRestoreGState(context);
}

-(CGContextRef)contextSave
{
    CGContextRef  ctxt = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctxt);
    
    return ctxt;
}

-(void)drawPoint:(CGPoint)point
{
    [self drawPoint:point color:nil];
}

-(void)drawPoint:(CGPoint)point color:(UIColor*)color
{
    CGRect  rect = CGRectMake(point.x, point.y, 1.0, 1.0);
    [self fillRect:rect color:color];
}

-(void)fillRect:(CGRect)rect
{
    [self fillRect:rect color:nil];
}

-(void)fillRect:(CGRect)rect color:(UIColor*)color
{
    CGContextRef  ctxt = [self contextSave];
    
    if (color)
    {
        CGContextSetFillColorWithColor(ctxt, [color CGColor]);
    }    
    
    UIRectFill(rect);
    [self contextRestore:ctxt];
}

-(void)fillRoundRect:(CGRect)rect
{
    [self fillRoundRect:rect color:nil];
}

-(void)fillRoundRect:(CGRect)rect color:(UIColor*)color
{
    CGContextRef  ctxt = [self contextSave];
    
    roundRect(ctxt, rect, kCornerSize, kCornerSize);
    
    if (color)
    {
        CGContextSetFillColorWithColor(ctxt, [color CGColor]);
    }    
    
    CGContextFillPath(ctxt);
    [self contextRestore:ctxt];
}

-(void)strokeRect:(CGRect)rect
{
    [self strokeRect:rect color:nil];
}

-(void)strokeRect:(CGRect)rect color:(UIColor*)color
{
    CGContextRef  ctxt = [self contextSave];
    
    if (color)
    {
        CGContextSetStrokeColorWithColor(ctxt, [color CGColor]);
    }    
    
    UIRectFrame(rect);
    [self contextRestore:ctxt];
}

-(void)strokeRoundRect:(CGRect)rect
{
    [self strokeRoundRect:rect color:nil];
}

-(void)strokeRoundRect:(CGRect)rect color:(UIColor*)color
{
    CGContextRef  ctxt = [self contextSave];
    
    rect = rectStrokeAdjust(rect);
    roundRect(ctxt, rect, kCornerSize, kCornerSize);
    
    if (color)
    {
        CGContextSetStrokeColorWithColor(ctxt, [color CGColor]);
    }    
    
    CGContextStrokePath(ctxt);
    [self contextRestore:ctxt];
}

SCRoundedRect SCRoundedRectMake(CGRect rect, CGFloat cornerRadius) {
    
	SCRoundedRect result;
	
	result.xLeft = CGRectGetMinX(rect);
	result.xLeftCorner = result.xLeft + cornerRadius;
	
	result.xRight = CGRectGetMaxX(rect);
	result.xRightCorner = result.xRight - cornerRadius;
	
	result.yTop = CGRectGetMinY(rect);
	result.yTopCorner = result.yTop + cornerRadius;
	
	result.yBottom = CGRectGetMaxY(rect);
	result.yBottomCorner = result.yBottom - cornerRadius;
	
	return result;
}

void SCContextAddRoundedRect(CGContextRef c, CGRect rect, CGFloat cornerRadius) {
	
	SCRoundedRect roundedRect = SCRoundedRectMake(rect, cornerRadius);
	
	/* Begin */
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, roundedRect.xLeft, roundedRect.yTopCorner);
	
	/* First corner */
	CGContextAddArcToPoint(c, roundedRect.xLeft, roundedRect.yTop, roundedRect.xLeftCorner, roundedRect.yTop, cornerRadius);
	CGContextAddLineToPoint(c, roundedRect.xRightCorner, roundedRect.yTop);
	
	/* Second corner */
	CGContextAddArcToPoint(c, roundedRect.xRight, roundedRect.yTop, roundedRect.xRight, roundedRect.yTopCorner, cornerRadius);
	CGContextAddLineToPoint(c, roundedRect.xRight, roundedRect.yBottomCorner);
	
	/* Third corner */
	CGContextAddArcToPoint(c, roundedRect.xRight, roundedRect.yBottom, roundedRect.xRightCorner, roundedRect.yBottom, cornerRadius);
	CGContextAddLineToPoint(c, roundedRect.xLeftCorner, roundedRect.yBottom);
	
	/* Fourth corner */
	CGContextAddArcToPoint(c, roundedRect.xLeft, roundedRect.yBottom, roundedRect.xLeft, roundedRect.yBottomCorner, cornerRadius);
	CGContextAddLineToPoint(c, roundedRect.xLeft, roundedRect.yTopCorner);
	
	/* Done */
	CGContextClosePath(c);
}

void SCContextAddLeftRoundedRect(CGContextRef c, CGRect rect, CGFloat radius) {
    
	SCRoundedRect roundedRect = SCRoundedRectMake(rect, radius);
	
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, roundedRect.xLeft, roundedRect.yTopCorner);
	
	CGContextAddArcToPoint(c, roundedRect.xLeft, roundedRect.yTop, roundedRect.xLeftCorner, roundedRect.yTop, radius);
	
	CGContextAddLineToPoint(c, roundedRect.xRight, roundedRect.yTop);
	CGContextAddLineToPoint(c, roundedRect.xRight, roundedRect.yBottom);
	CGContextAddLineToPoint(c, roundedRect.xLeftCorner, roundedRect.yBottom);
	
	CGContextAddArcToPoint(c, roundedRect.xLeft, roundedRect.yBottom, roundedRect.xLeft, roundedRect.yBottomCorner, radius);
	
	CGContextClosePath(c);
}

void SCContextAddLeftTopRoundedRect(CGContextRef c, CGRect rect, CGFloat radius) {
	
	SCRoundedRect roundedRect = SCRoundedRectMake(rect, radius);
	
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, roundedRect.xLeft, roundedRect.yTopCorner);
	
	CGContextAddArcToPoint(c, roundedRect.xLeft, roundedRect.yTop, roundedRect.xLeftCorner, roundedRect.yTop, radius);
	
	CGContextAddLineToPoint(c, roundedRect.xRight, roundedRect.yTop);
	CGContextAddLineToPoint(c, roundedRect.xRight, roundedRect.yBottom);
	CGContextAddLineToPoint(c, roundedRect.xLeft, roundedRect.yBottom);
	
	CGContextClosePath(c);
}

void SCContextAddLeftBottomRoundedRect(CGContextRef c, CGRect rect, CGFloat radius) {
    
	SCRoundedRect roundedRect = SCRoundedRectMake(rect, radius);
	
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, roundedRect.xLeft, roundedRect.yTop);
	
	CGContextAddLineToPoint(c, roundedRect.xRight, roundedRect.yTop);
	CGContextAddLineToPoint(c, roundedRect.xRight, roundedRect.yBottom);
	CGContextAddLineToPoint(c, roundedRect.xLeftCorner, roundedRect.yBottom);
	
	CGContextAddArcToPoint(c, roundedRect.xLeft, roundedRect.yBottom, roundedRect.xLeft, roundedRect.yBottomCorner, radius);
	
	CGContextClosePath(c);
}

void SCContextAddRightRoundedRect(CGContextRef c, CGRect rect, CGFloat radius) {
    
	SCRoundedRect roundedRect = SCRoundedRectMake(rect, radius);
	
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, roundedRect.xLeft, roundedRect.yTop);
	
	CGContextAddLineToPoint(c, roundedRect.xRightCorner, roundedRect.yTop);
	CGContextAddArcToPoint(c, roundedRect.xRight, roundedRect.yTop, roundedRect.xRight, roundedRect.yTopCorner, radius);
	CGContextAddLineToPoint(c, roundedRect.xRight, roundedRect.yBottomCorner);
	CGContextAddArcToPoint(c, roundedRect.xRight, roundedRect.yBottom, roundedRect.xRightCorner, roundedRect.yBottom, radius);
	CGContextAddLineToPoint(c, roundedRect.xLeft, roundedRect.yBottom);
	
	CGContextClosePath(c);
}

void SCContextAddRightTopRoundedRect(CGContextRef c, CGRect rect, CGFloat radius) {
	
	SCRoundedRect roundedRect = SCRoundedRectMake(rect, radius);
	
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, roundedRect.xLeft, roundedRect.yTop);
	
	CGContextAddLineToPoint(c, roundedRect.xRightCorner, roundedRect.yTop);
	CGContextAddArcToPoint(c, roundedRect.xRight, roundedRect.yTop, roundedRect.xRight, roundedRect.yTopCorner, radius);
	CGContextAddLineToPoint(c, roundedRect.xRight, roundedRect.yBottom);
	CGContextAddLineToPoint(c, roundedRect.xLeft, roundedRect.yBottom); 
	
	CGContextClosePath(c);
}

void SCContextAddRightBottomRoundedRect(CGContextRef c, CGRect rect, CGFloat radius) {
	
	SCRoundedRect roundedRect = SCRoundedRectMake(rect, radius);
	
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, roundedRect.xLeft, roundedRect.yTop);
	
	CGContextAddLineToPoint(c, roundedRect.xRight, roundedRect.yTop);
	CGContextAddLineToPoint(c, roundedRect.xRight, roundedRect.yBottomCorner);
	CGContextAddArcToPoint(c, roundedRect.xRight, roundedRect.yBottom, roundedRect.xRightCorner, roundedRect.yBottom, radius);
	CGContextAddLineToPoint(c, roundedRect.xLeft, roundedRect.yBottom);
	
	CGContextClosePath(c);
}


@end



@implementation UIImageView (MFAdditions)

- (void) setImageWithName:(NSString *)name {
	
	[self setImage:[UIImage imageNamed:name]];
	[self sizeToFit];
}

@end






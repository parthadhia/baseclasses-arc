//
//  Loader.m
//  pvhs
//
//  Created by Denny Kwon on 9/15/12.
//  Copyright (c) 2012 Pascack Valley Regional District. All rights reserved.
//

#import "Loader.h"

@implementation Loader
@synthesize titleLabel;
@synthesize darkScreen;
@synthesize spinner;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure:frame offset:0];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame verticalOffset:(int)offset
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure:frame offset:offset];
    }
    return self;
}

- (void)configure:(CGRect)frame offset:(int)offset
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    CGFloat width = 160.0f;
    CGFloat height = 100.0f;
    CGFloat y = 0.5*(frame.size.height-height)+offset;
    
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0.5*(frame.size.width-width), y, width, height)];
    
    self.darkScreen = background;
//    [background release];
    
    darkScreen.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);;
    darkScreen.layer.cornerRadius = 8.0f;
    darkScreen.backgroundColor = [UIColor blackColor];
    darkScreen.alpha = 0.7f;
    [self addSubview:darkScreen];
//    [darkScreen release];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.5*(frame.size.width-width), y+10, width, 35)];
    titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
    titleLabel.text = @"Loading...";
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    
    width = 20.0f;
    spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.5*(frame.size.width-width), y+45, width, width)];
    spinner.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
    [self addSubview:spinner];
}

- (void)show
{
    [spinner startAnimating];
    if (!self.hidden)
        return;
    
    self.alpha = 0.0f;
    self.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    self.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void)hide
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDone)];
    self.alpha = 0.0f;
    [UIView commitAnimations];
    
    
    //    self.hidden = TRUE;
    //    [spinner stopAnimating];
}

- (void)animationDone
{
    self.hidden = TRUE;
    [spinner stopAnimating];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

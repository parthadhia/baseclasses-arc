//
//  Loader.h
//  pvhs
//
//  Created by Denny Kwon on 9/15/12.
//  Copyright (c) 2012 Pascack Valley Regional District. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface Loader : UIView {
    
}

@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UIView *darkScreen;
@property (strong, nonatomic) UILabel *titleLabel;
- (id)initWithFrame:(CGRect)frame verticalOffset:(int)offset;
- (void)show;
- (void)hide;
@end

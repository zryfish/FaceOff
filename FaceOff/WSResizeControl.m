//
//  WSResizeControl.m
//  UITest
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import "WSResizeControl.h"

@interface WSResizeControl()

@property (nonatomic, readwrite) CGPoint translation;
@property (nonatomic) CGPoint startPoint;

@end

@implementation WSResizeControl

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 44.0f, 44.0f)]) {
        self.backgroundColor = [UIColor clearColor];
        self.exclusiveTouch = YES;
        
        UIPanGestureRecognizer * gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:gestureRecognizer];
    }
    
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint translationInView = [gestureRecognizer translationInView:self.superview];
        self.startPoint = CGPointMake(roundf(translationInView.x), translationInView.y);
        
        if ([self.delegate respondsToSelector:@selector(resizeControllViewDidBeginResizing:)]) {
            [self.delegate resizeControllViewDidBeginResizing:self];
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:self.superview];
        self.translation = CGPointMake(roundf(self.startPoint.x + translation.x), roundf(self.startPoint.y + translation.y));
        
        if ([self.delegate respondsToSelector:@selector(resizeControllViewDidResize:)]) {
            [self.delegate resizeControllViewDidResize:self];
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
               gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        if ([self.delegate respondsToSelector:@selector(resizeControllViewDidEndResizing:)]) {
            [self.delegate resizeControllViewDidEndResizing:self];
        }
    }
}

@end

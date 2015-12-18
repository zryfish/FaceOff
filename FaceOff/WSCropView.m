//
//  WSCropView.m
//  UITest
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import "WSCropView.h"
#import "WSCropRectView.h"

@interface WSCropView() <UIScrollViewDelegate, UIGestureRecognizerDelegate, WSCropRectViewDelegate>

@property (nonatomic) UIScrollView * scrollView;

@property (nonatomic) WSCropRectView * cropRectView;
@property (nonatomic) UIView * topOverlapView;
@property (nonatomic) UIView * leftOverlayView;
@property (nonatomic) UIView * rightOverlayView;
@property (nonatomic) UIView * bottomOverlayView;

@property (nonatomic) CGRect insetRect;
@property (nonatomic) CGRect editingRect;

@property (nonatomic, getter=isResizing) BOOL resizing;
@property (nonatomic) UIInterfaceOrientation interfaceOrientation;

@end

@implementation WSCropView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor clearColor] setFill];
    UIRectFill(self.cropRectView.frame);
}

- (void)commonInit {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor clearColor];
    
    self.cropRectView = [[WSCropRectView alloc] initWithFrame:CGRectMake(0, 80, self.bounds.size.width, self.bounds.size.height / 2)];
    self.cropRectView.delegate = self;
    [self addSubview:self.cropRectView];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.userInteractionEnabled) {
        return nil;
    }
    
    UIView * hitView = [self.cropRectView hitTest:[self convertPoint:point toView:self.cropRectView] withEvent:event];
    if (hitView) {
        return hitView;
    }
    
    return [super hitTest:point withEvent:event];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.editingRect = CGRectMake(0, 50, self.bounds.size.width / 3, self.bounds.size.height / 3);
    
    self.insetRect = CGRectInset(self.bounds, 0.0f, 0.0f);
    
    if (!self.isResizing) {
        //[self layoutCropRectViewWithCropRect:self.editingRect]
    }
}

- (void)layoutCropRectViewWithCropRect:(CGRect)cropRect {
    self.cropRectView.frame = cropRect;
}

- (CGRect)cropRect {
    return self.cropRectView.frame;
}

- (void)resetCropRect {
    [self resetCropRectAnimated:NO];
}

- (void)resetCropRectAnimated:(BOOL)animated {
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    
    CGSize contentSize = self.bounds.size;
    CGRect initialRect = CGRectMake(0.0f, 0.0f, contentSize.width, contentSize.height);
    
    [self layoutCropRectViewWithCropRect:initialRect];
    
    if (animated) {
        [UIView commitAnimations];
    }
}

- (CGRect)cappedCropRectInImageRectWithCropRectView:(WSCropRectView *)cropRectView {
    CGRect cropRect = cropRectView.frame;
    
    if (CGRectGetMinY(cropRect) < CGRectGetMinY(self.bounds)) {
        CGFloat diff = CGRectGetMinY(self.bounds) - CGRectGetMinY(cropRect);
        cropRect.origin.y = CGRectGetMinY(self.bounds);
        cropRect.size = CGSizeMake(cropRect.size.width, cropRect.size.height - diff);
    }
    
    if (CGRectGetMaxY(cropRect) > CGRectGetMaxY(self.bounds)) {
        CGFloat diff = CGRectGetMaxY(cropRect) - CGRectGetMaxY(self.bounds);
        cropRect.origin.y = CGRectGetMaxY(self.bounds);
        cropRect.size = CGSizeMake(cropRect.size.width, cropRect.size.height - diff);
    }
    
    return cropRect;
}

#pragma mark - WSCropRectView delegate
- (void)cropRectViewDidBeginEditing:(WSCropRectView *)cropRectView {
    self.resizing = YES;
}

- (void)cropRectViewDidEditingChanged:(WSCropRectView *)cropRectView {
    CGRect cropRect = [self cappedCropRectInImageRectWithCropRectView:cropRectView];
    
    [self layoutCropRectViewWithCropRect:cropRect];
    [self setNeedsDisplay];
}

- (void)cropRectViewDidEndEditing:(WSCropRectView *)cropRectView {
    self.resizing = NO;
}

@end

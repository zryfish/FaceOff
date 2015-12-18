//
//  WSCropRectView.m
//  UITest
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import "WSCropRectView.h"
#import "WSResizeControl.h"

@interface WSCropRectView() <WSResizeControllViewDelegate>

@property (nonatomic) WSResizeControl *topLeftCornerView;
@property (nonatomic) WSResizeControl *topRightCornerView;
@property (nonatomic) WSResizeControl *bottomLeftCornerView;
@property (nonatomic) WSResizeControl *bottomRightCornerView;
@property (nonatomic) WSResizeControl *topEdgeView;
@property (nonatomic) WSResizeControl *leftEdgeView;
@property (nonatomic) WSResizeControl *bottomEdgeView;
@property (nonatomic) WSResizeControl *rightEdgeView;

@property (nonatomic) CGRect initialRect;


@end



@implementation WSCropRectView

void printCGRect1(NSString * leadingText, CGRect frame) {
    NSLog(@"%@ with origin: %f %f  size: %f X %f\n", leadingText, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        
        self.showGridMajor = NO;
        self.showGridMinor = NO;
        printCGRect1(@"initial frame ", frame);
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        
        printCGRect1(@"crop view frame", imageView.frame);
        
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.image = [[UIImage imageNamed:@"WSCropRectView.bundle/WSPhotoCropEditorBorder"] resizableImageWithCapInsets:UIEdgeInsetsMake(23.0f, 23.0f, 23.0f, 23.0f)];
        [self addSubview:imageView];
        
        self.topLeftCornerView = [[WSResizeControl alloc] init];
        self.topLeftCornerView.delegate = self;
        [self addSubview:self.topLeftCornerView];
        
        self.topRightCornerView = [[WSResizeControl alloc] init];
        self.topRightCornerView.delegate = self;
        [self addSubview:self.topRightCornerView];
        
        self.bottomLeftCornerView = [[WSResizeControl alloc] init];
        self.bottomLeftCornerView.delegate = self;
        [self addSubview:self.bottomLeftCornerView];
        
        self.bottomRightCornerView = [[WSResizeControl alloc] init];
        self.bottomRightCornerView.delegate = self;
        [self addSubview:self.bottomRightCornerView];
        
        self.topEdgeView = [[WSResizeControl alloc] init];
        self.topEdgeView.delegate = self;
        [self addSubview:self.topEdgeView];
        
        self.leftEdgeView = [[WSResizeControl alloc] init];
        self.leftEdgeView.delegate = self;
        [self addSubview:self.leftEdgeView];
        
        self.bottomEdgeView = [[WSResizeControl alloc] init];
        self.bottomEdgeView.delegate = self;
        [self addSubview:self.bottomEdgeView];
        
        self.rightEdgeView = [[WSResizeControl alloc] init];
        self.rightEdgeView.delegate = self;
        [self addSubview:self.rightEdgeView];
    }
    
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSArray * subviews = self.subviews;
    for (UIView * subview in subviews) {
        if ([subview isKindOfClass:[WSResizeControl class]]) {
            if (CGRectContainsPoint(subview.frame, point)) {
                return subview;
            }
        }
    }
    
    return nil;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    for (NSInteger i = 1; i < 3; i++) {
        CGFloat borderPadding = 2.0f;
        
        if (self.showGridMajor) {
                [[UIColor whiteColor] set];
                
                UIRectFill(CGRectMake(roundf(width / 3 * i), borderPadding, 1.0f, roundf(height) - borderPadding * 2));
                UIRectFill(CGRectMake(borderPadding, roundf(height / 3 * i), roundf(width) - borderPadding * 2, 1.0f));
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.topLeftCornerView.frame = (CGRect){CGRectGetWidth(self.topLeftCornerView.bounds) / -2, CGRectGetHeight(self.topLeftCornerView.bounds) / -2, self.topLeftCornerView.bounds.size};
    self.topRightCornerView.frame = (CGRect){CGRectGetWidth(self.bounds) - CGRectGetWidth(self.topRightCornerView.bounds) / 2, CGRectGetHeight(self.topRightCornerView.bounds) / -2, self.topLeftCornerView.bounds.size};
    self.bottomLeftCornerView.frame = (CGRect){CGRectGetWidth(self.bottomLeftCornerView.bounds) / -2, CGRectGetHeight(self.bounds) - CGRectGetHeight(self.bottomLeftCornerView.bounds) / 2, self.bottomLeftCornerView.bounds.size};
    self.bottomRightCornerView.frame = (CGRect){CGRectGetWidth(self.bounds) - CGRectGetWidth(self.bottomRightCornerView.bounds) / 2, CGRectGetHeight(self.bounds) - CGRectGetHeight(self.bottomRightCornerView.bounds) / 2, self.bottomRightCornerView.bounds.size};
    self.topEdgeView.frame = (CGRect){CGRectGetMaxX(self.topLeftCornerView.frame), CGRectGetHeight(self.topEdgeView.frame) / -2, CGRectGetMinX(self.topRightCornerView.frame) - CGRectGetMaxX(self.topLeftCornerView.frame), CGRectGetHeight(self.topEdgeView.bounds)};
    self.leftEdgeView.frame = (CGRect){CGRectGetWidth(self.leftEdgeView.frame) / -2, CGRectGetMaxY(self.topLeftCornerView.frame), CGRectGetWidth(self.leftEdgeView.bounds), CGRectGetMinY(self.bottomLeftCornerView.frame) - CGRectGetMaxY(self.topLeftCornerView.frame)};
    self.bottomEdgeView.frame = (CGRect){CGRectGetMaxX(self.bottomLeftCornerView.frame), CGRectGetMinY(self.bottomLeftCornerView.frame), CGRectGetMinX(self.bottomRightCornerView.frame) - CGRectGetMaxX(self.bottomLeftCornerView.frame), CGRectGetHeight(self.bottomEdgeView.bounds)};
    self.rightEdgeView.frame = (CGRect){CGRectGetWidth(self.bounds) - CGRectGetWidth(self.rightEdgeView.bounds) / 2, CGRectGetMaxY(self.topRightCornerView.frame), CGRectGetWidth(self.rightEdgeView.bounds), CGRectGetMinY(self.bottomRightCornerView.frame) - CGRectGetMaxY(self.topRightCornerView.frame)};
}


- (void)setShowGridMajor:(BOOL)showGridMajor {
    _showGridMajor = showGridMajor;
    [self setNeedsDisplay];
}

- (void)setShowGridMinor:(BOOL)showGridMinor {
    _showGridMinor = showGridMinor;
    [self setNeedsDisplay];
}

#pragma mark - WSResizeControll delegate

- (void)resizeControllViewDidBeginResizing:(WSResizeControl *)resizeControllView {
    self.initialRect = self.frame;
    
    if ([self.delegate respondsToSelector:@selector(cropRectViewDidBeginEditing:)]) {
        [self.delegate cropRectViewDidBeginEditing:self];
    }
}

- (void)resizeControllViewDidResize:(WSResizeControl *)resizeControllView {
    self.frame = [self cropRectMakeWithResizeControllView:resizeControllView];
    
    if ([self.delegate respondsToSelector:@selector(cropRectViewDidEditingChanged:)]) {
        [self.delegate cropRectViewDidEditingChanged:self];
    }
}

- (void)resizeControllViewDidEndResizing:(WSResizeControl *)resizeControllView {
    if ([self.delegate respondsToSelector:@selector(cropRectViewDidEndEditing:)]) {
        [self.delegate cropRectViewDidEndEditing:self];
    }
}

- (CGRect)cropRectMakeWithResizeControllView:(WSResizeControl *)resizeControllView {
    CGRect rect = self.frame;
    
    if (resizeControllView == self.topEdgeView) {
        rect = CGRectMake(CGRectGetMinX(self.initialRect),
                          CGRectGetMinY(self.initialRect) + resizeControllView.translation.y,
                          CGRectGetWidth(self.initialRect),
                          CGRectGetHeight(self.initialRect) - resizeControllView.translation.y);
    } else if (resizeControllView == self.bottomEdgeView) {
        rect = CGRectMake(CGRectGetMinX(self.initialRect),
                          CGRectGetMinY(self.initialRect),
                          CGRectGetWidth(self.initialRect),
                          CGRectGetHeight(self.initialRect) + resizeControllView.translation.y);
    }
    
    CGFloat minWidth = CGRectGetWidth(self.leftEdgeView.bounds) + CGRectGetWidth(self.rightEdgeView.bounds);
    if (CGRectGetWidth(rect) < minWidth) {
        rect.origin.x = CGRectGetMaxX(self.frame) - minWidth;
        rect.size.width = minWidth;
    }
    
    CGFloat minHeight = CGRectGetHeight(self.topEdgeView.bounds) + CGRectGetHeight(self.bottomEdgeView.bounds);
    if (CGRectGetHeight(rect) < minHeight) {
        rect.origin.y = CGRectGetMaxY(self.frame) - minHeight;
        rect.size.height = minHeight;
    }
    
    return rect;
}

@end

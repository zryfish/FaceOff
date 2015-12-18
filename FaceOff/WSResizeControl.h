//
//  WSResizeControl.h
//  UITest
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol WSResizeControllViewDelegate;


@interface WSResizeControl : UIView

@property (nonatomic, weak) id<WSResizeControllViewDelegate> delegate;
@property (nonatomic, readonly) CGPoint translation;

@end

@protocol WSResizeControllViewDelegate <NSObject>

- (void)resizeControllViewDidBeginResizing:(WSResizeControl *)resizeControllView;
- (void)resizeControllViewDidResize:(WSResizeControl *)resizeControllView;
- (void)resizeControllViewDidEndResizing:(WSResizeControl *)resizeControllView;

@end
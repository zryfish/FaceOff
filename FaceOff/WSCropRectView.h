//
//  WSCropRectView.h
//  UITest
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WSCropRectViewDelegate;

@interface WSCropRectView : UIView

@property (nonatomic, weak) id<WSCropRectViewDelegate> delegate;
@property (nonatomic) BOOL showGridMajor;
@property (nonatomic) BOOL showGridMinor;

@end

@protocol WSCropRectViewDelegate <NSObject>

- (void)cropRectViewDidBeginEditing:(WSCropRectView *)cropRectView;
- (void)cropRectViewDidEditingChanged:(WSCropRectView *)cropRectView;
- (void)cropRectViewDidEndEditing:(WSCropRectView *)cropRectView;

@end

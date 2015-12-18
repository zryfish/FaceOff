//
//  MWGridCell.m
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 08/10/2013.
//
//

#import "MWGridCell.h"
#import "UIImage+MWPhotoBrowser.h"

#define VIDEO_INDICATOR_PADDING 10

@interface MWGridCell () {
    UIImageView *_imageView;
    UIButton *_selectedButton;
}

@end

@implementation MWGridCell

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Grey background
        self.backgroundColor = [UIColor colorWithWhite:0.12 alpha:1];
        //self.backgroundColor = [UIColor whiteColor];
        // Image
        _imageView = [UIImageView new];
        _imageView.frame = self.bounds;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        _imageView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_imageView];
        
        // Selection button
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedButton.contentMode = UIViewContentModeTopRight;
        _selectedButton.adjustsImageWhenHighlighted = NO;
        [_selectedButton setImage:[UIImage imageForResourcePath:@"WSView.bundle/ImageSelectedSmallOff" ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]] forState:UIControlStateNormal];
        [_selectedButton setImage:[UIImage imageForResourcePath:@"WSView.bundle/ImageSelectedSmallOn" ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]] forState:UIControlStateSelected];
        [_selectedButton addTarget:self action:@selector(selectionButtonPressed) forControlEvents:UIControlEventTouchDown];
        _selectedButton.hidden = YES;
        _selectedButton.frame = CGRectMake(0, 0, 25, 25);
        [self addSubview:_selectedButton];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - View

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;

    _selectedButton.frame = CGRectMake(self.bounds.size.width - _selectedButton.frame.size.width - 0,
                                       0, _selectedButton.frame.size.width, _selectedButton.frame.size.height);
}

#pragma mark - Cell

- (void)prepareForReuse {
    _photo = nil;
    _gridController = nil;
    _imageView.image = nil;
    _selectedButton.hidden = YES;
    [super prepareForReuse];
}

#pragma mark - Image Handling

- (void)setPhoto:(UIImage *)photo {
    _photo = photo;
}

- (void)displayImage {
    _imageView.image = _photo;
    _selectedButton.hidden = !_selectionMode;
    //[self hideImageFailure];
}

#pragma mark - Selection

- (void)setSelectionMode:(BOOL)selectionMode {
    _selectionMode = selectionMode;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    _selectedButton.selected = isSelected;
}

- (void)selectionButtonPressed {
    _selectedButton.selected = !_selectedButton.selected;
    [_gridController setCellSelected:_selectedButton.selected atIndex:_index];
    //[_gridController.browser setPhotoSelected:_selectedButton.selected atIndex:_index];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _imageView.alpha = 0.6;
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    _imageView.alpha = 1;
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    _imageView.alpha = 1;
    [super touchesCancelled:touches withEvent:event];
}


@end

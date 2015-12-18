//
//  MWGridViewController.h
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 08/10/2013.
//
//

#import <UIKit/UIKit.h>
//#import "MWPhotoBrowser.h"

@interface MWGridViewController : UICollectionViewController <UIImagePickerControllerDelegate> {}

//@property (nonatomic, assign) MWPhotoBrowser *browser;
//@property (nonatomic) NSMutableArray * photos;
@property (nonatomic) BOOL selectionMode;
@property (nonatomic) CGPoint initialContentOffset;



- (void)adjustOffsetsAsRequired;
- (void)setCellSelected:(BOOL)selected atIndex:(NSUInteger)index;
- (BOOL)cellIsSelectedAtIndex:(NSUInteger)index;
@end

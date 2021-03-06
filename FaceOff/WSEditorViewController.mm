//
//  ViewController.m
//  FaceOff
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015 Malus. All rights reserved.
//

#import "WSEditorViewController.h"
#import "WSMenuItemCell.h"
#import "WSMenuItemTitleView.h"
#import "WSAvatar.h"
#import "WSAvatarManager.h"
#import "WSVerticalScrollMenuLayout.h"
#import "WSCropView.h"
#import "WSShareView.h"
#import "Configuration.h"
#import "AvatarReplacor.h"
#import <opencv2/opencv.hpp>
#import "UIImage+OpenCV.h"

typedef NS_ENUM(NSInteger, ViewPosition) {
    PositionLeft = 1 << 0,
    PositionCenter = 1 << 1,
    PositionRight = 1 << 2,
    PositionCrop = 1 << 3,
    PositionShare = 1 << 4
};

@interface WSEditorViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIView * canvas;
@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UIToolbar * toolbar;

@property (strong, nonatomic) UICollectionView * currentMenu;
@property (strong, nonatomic) WSAvatar * currentAvatar;
@property (strong, nonatomic) WSAvatarManager * avatarManager;
@property (strong, nonatomic) WSCropView * cropView;
@property (nonatomic) ViewPosition currentPosition;

@property (strong, nonatomic) WSShareView * shareView;

@property (strong, nonatomic) UIImage * originalImage;
@property (strong, nonatomic) UIImage * resultImage;

@property (nonatomic, assign) AvatarReplacor* ap;
@property (nonatomic) BOOL isTitleReplaced;
@property (nonatomic) int selectedAvatar;

@end

const static CGFloat SidePadding = 100.0f;
const static CGFloat SideRegionWidth = 120.0f;

@implementation WSEditorViewController


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.imageView];
    
    ViewPosition touchPosition = [self touchPosition:touchPoint];
    
    if (touchPosition == PositionLeft) {
        NSLog(@"select left avatar %d \n", self.ap->containsPointInLeft(touchPoint.x, touchPoint.y));
        self.selectedAvatar = self.ap->containsPointInLeft(touchPoint.x, touchPoint.y);
    } else if (touchPosition == PositionRight) {
        NSLog(@"select right avatar %d \n", self.ap->containsPointInRight(touchPoint.x, touchPoint.y));
        self.selectedAvatar = self.ap->containsPointInRight(touchPoint.x, touchPoint.y);
    }
}

- (ViewPosition)touchPosition:(CGPoint)touchPoint {
    if (touchPoint.x <  SideRegionWidth && touchPoint.x > 0) {
        return PositionLeft;
    } else if (touchPoint.x < self.imageView.frame.size.width &&
               touchPoint.x > self.imageView.frame.size.width - SideRegionWidth) {
        return PositionRight;
    } else {
        return PositionCenter;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.canvas = [[UIView alloc] init];
    self.imageView = [[UIImageView alloc] init];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    [self.canvas setFrame:CGRectMake(-SidePadding, 0, screenRect.size.width + 2 * SidePadding, screenRect.size.height)];
    [self.view addSubview:self.canvas];
    [self.imageView setFrame:CGRectMake(SidePadding, 0, screenRect.size.width, screenRect.size.height)];
    [self.canvas addSubview:self.imageView];
    self.canvas.backgroundColor = [UIColor blackColor];
    
    self.currentMenu = nil;
    self.avatarManager = [[WSAvatarManager alloc] init];
    self.currentPosition = PositionCenter;
    
    [self initializeReplacor];
    self.isTitleReplaced = NO;
    self.selectedAvatar = -1;
    
    UISwipeGestureRecognizer * swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer * swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.imageView addGestureRecognizer:swipeRight];
    [self.imageView addGestureRecognizer:swipeLeft];
    
    self.imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [doubleTap setNumberOfTouchesRequired:1];
    [self.canvas addGestureRecognizer:doubleTap];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Left Swipe");
        if (self.currentPosition == PositionCenter) {
            [self moveCanvas:PositionRight];
        } else if (self.currentPosition == PositionLeft) {
            [self moveCanvas:PositionCenter];
        }
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Right Swipe");
        if (self.currentPosition == PositionCenter) {
            [self moveCanvas:PositionLeft];
        } else if (self.currentPosition == PositionRight) {
            [self moveCanvas:PositionCenter];
        }
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded && self.currentMenu) {
        CGPoint point = [tap locationInView:self.currentMenu];
        NSIndexPath * indexPath = [self.currentMenu indexPathForItemAtPoint:point];
        if (indexPath) {
            NSLog(@"item %ld was double taped", (long)indexPath.row);
            self.currentAvatar = self.avatarManager.avatars[indexPath.row];
            
            NSLog(@"select avatar %@ \n", self.currentAvatar.imageName);
            
            Mat avatar = [[UIImage imageNamed:self.currentAvatar.imageName] CVMat];
            if (self.currentPosition == PositionLeft) {
                self.ap->replaceAvatar(avatar, SIDE_LEFT);
            } else if (self.currentPosition == PositionRight) {
                self.ap->replaceAvatar(avatar, SIDE_RIGHT);
            }
            self.imageView.image = [UIImage imageWithCVMat:self.ap->getResultImage()];
        } else {
            NSLog(@"nothing happened");
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.image) {
        self.imageView.image = self.image;
        Mat imageMat = [self.image CVMat];
        self.ap->setImage(imageMat);
    }
    
    self.shareView = [[WSShareView alloc] init];
    self.shareView.frame = CGRectMake(SidePadding, self.imageView.frame.size.height, self.imageView.frame.size.width, self.imageView.frame.size.height / 4);
    [self.canvas addSubview:self.shareView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupEditorToolbar];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)dealloc {
    delete self.ap;
    
    NSLog(@"dealloc called");
}

- (cv::Rect)rectToCVRect:(CGRect)rect {
    cv::Rect cr = cv::Rect(cv::Point(rect.origin.x, rect.origin.y), cv::Size(rect.size.width, rect.size.height));
    return cr;
}

- (void)initializeReplacor {
    Configuration * conf = [Configuration sharedConfiguration];
    
    self.ap = new AvatarReplacor();
    self.ap->setLeftRegion([self rectToCVRect:conf.leftRect]);
    self.ap->setRightRegion([self rectToCVRect:conf.rightRect]);
    self.ap->setTopRegion([self rectToCVRect:conf.topRect]);
    self.ap->setBackgroundColorThresh((int)conf.backgroundColorThresh);
    self.ap->setAvatarMinSize(conf.minAvatarSize.width, conf.minAvatarSize.height);
    self.ap->setAvatarMaxSize(conf.maxAvatarSize.width, conf.maxAvatarSize.height);
    self.ap->setFontSize((int)conf.fontSize);
    self.ap->setScreenScale(conf.scale);
    self.ap->finishInitialization();
}

- (void)setupEditorToolbar {
    UIBarButtonItem * flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * discardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(discardChange:)];
    UIBarButtonItem * editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(replaceAvatar:)];
    UIBarButtonItem * shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    NSArray * items = [NSArray arrayWithObjects:discardButton, flexibleSpace, editButton, flexibleSpace, shareButton, nil];
    for (UIBarButtonItem * item in items)
    {
        item.tintColor = [UIColor whiteColor];
    }
    NSLog(@"view frame %f %f %f %f\n", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    [self.toolbar setItems:items];
    self.toolbar.barTintColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.8f alpha:1.0f];
    self.toolbar.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    [self.view addSubview:self.toolbar];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.avatarManager.avatars.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WSMenuItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WSMenuItemCell" forIndexPath:indexPath];
    WSAvatar * avatar = self.avatarManager.avatars[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:avatar.imageName];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    WSMenuItemTitleView * titleView = [collectionView dequeueReusableSupplementaryViewOfKind:@"title" withReuseIdentifier:@"WSMenuItemTitleView" forIndexPath:indexPath];
    WSAvatar * avatar = self.avatarManager.avatars[indexPath.row];
    titleView.label.text = avatar.imageName;
    
    return titleView;
}

#pragma mark - UICollectionView delegate methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedAvatar == -1) {
        NSLog(@"no avatar was selected");
    } else {
        SIDE whichSide = SIDE_LEFT;
        if (self.currentPosition == PositionLeft) {
            whichSide = SIDE_LEFT;
        } else if (self.currentPosition == PositionRight) {
            whichSide = SIDE_RIGHT;
        }
        self.currentAvatar = self.avatarManager.avatars[indexPath.row];
        Mat avatar = [[UIImage imageNamed:self.currentAvatar.imageName] CVMat];
        self.ap->replaceAvatar(avatar, whichSide, self.selectedAvatar);
        self.imageView.image = [UIImage imageWithCVMat:self.ap->getResultImage()];
    }
}


- (void)moveCanvas:(ViewPosition)position {
    if (position == self.currentPosition) {
        return;
    } else if (self.currentPosition != PositionCenter && position != PositionCenter) {
        position = PositionCenter;
    }
    
    UICollectionView * previousMenu = self.currentMenu;
    CGFloat ratio = 0;
    
    switch (position) {
        case PositionLeft:
            ratio = 1.0f;
            break;
        case PositionRight:
            ratio = -1.0f;
            break;
        case PositionCenter:
            ratio = 0.0f;
            break;
        default:
            return;
            break;
    }
    
    if (!self.currentMenu) {
        [self configureScrollMenu:position];
        [self.canvas addSubview:self.currentMenu];
    
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.canvas setFrame:CGRectMake(-SidePadding + ratio * self.currentMenu.collectionViewLayout.
                                             collectionViewContentSize.width,
                                             0, self.canvas.frame.size.width, self.canvas.frame.size.height)];
        } completion:^(BOOL finished) {
            NSLog(@"Menu showed");
        }];
    } else {
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.canvas setFrame:CGRectMake(-SidePadding + ratio * self.currentMenu.collectionViewLayout.collectionViewContentSize.width, 0, self.canvas.frame.size.width, self.canvas.frame.size.width)];
        }completion:^(BOOL finished) {
            self.currentMenu = nil;
            
            if (previousMenu) {
                [previousMenu removeFromSuperview];
            }
        }];
    }
    
    self.currentPosition = position;
    self.selectedAvatar = -1;
}

- (void)configureScrollMenu:(ViewPosition)position {
    if (position == PositionCenter || position == PositionCrop || position == PositionShare) {
        return;
    }
    
    CGFloat menuLayoutX = 0.0f;
    WSVerticalScrollMenuLayout * scrollMenuLayout = [[WSVerticalScrollMenuLayout alloc] init];
    self.currentMenu = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:scrollMenuLayout];
    
    if (position == PositionLeft) {
        menuLayoutX = self.imageView.frame.origin.x - scrollMenuLayout.collectionViewContentSize.width;
    } else if (position == PositionRight) {
        menuLayoutX = self.imageView.frame.origin.x + self.imageView.frame.size.width;
    }
    
    self.currentMenu.frame = CGRectMake(menuLayoutX,
                                        self.imageView.frame.origin.y,
                                        scrollMenuLayout.collectionViewContentSize.width,
                                        self.imageView.frame.size.height);
    
    UINib * cellNib = [UINib nibWithNibName:@"WSMenuItemCell" bundle:nil];
    [self.currentMenu registerNib:cellNib forCellWithReuseIdentifier:@"WSMenuItemCell"];
    [self.currentMenu registerClass:[WSMenuItemCell class] forSupplementaryViewOfKind:@"title" withReuseIdentifier:@"WSMenuItemTitleView"];
    
    self.currentMenu.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
    self.currentMenu.delegate = self;
    self.currentMenu.dataSource = self;
}

- (IBAction)discardChange:(id)sender {
    NSLog(@"Discard Change");
    Mat image = [self.imageView.image CVMat];
    if (self.ap->isModified(image) == true) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"返回主界面" message:@"保存编辑的图片？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", @"不保存", nil];
        [alert show];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            return;
            break;
        case 1:
            UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil, nil);
        case 2:
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [self dismissViewControllerAnimated:YES completion:^{
                NSLog(@"back to main view");
            }];
            break;
            
        default:
            break;
    }
}

- (IBAction)replaceAvatar:(id)sender {
    NSLog(@"Replace Avatar");
    self.isTitleReplaced = !self.isTitleReplaced;
    self.ap->replaceTitle(self.isTitleReplaced ? true : false);
    self.imageView.image = [UIImage imageWithCVMat:self.ap->getResultImage()];
}

- (IBAction)share:(id)sender {
    NSLog(@"Share");
    
    if (self.currentPosition == PositionShare) {
        [UIView animateWithDuration:0.3 animations:^{
            CALayer * layer = self.imageView.layer;
            layer.zPosition = -4000;
            CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
            rotationAndPerspectiveTransform.m34 = 1.0 / 300;
            layer.shadowOpacity = 0.01;
            layer.transform = CATransform3DRotate(rotationAndPerspectiveTransform, -10.0f * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
        }completion:^(BOOL finished) {
            NSLog(@"");
            [UIView animateWithDuration:0.2 animations:^{
                self.imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                self.imageView.alpha = 1.0f;
                self.shareView.frame = CGRectMake(SidePadding, self.imageView.frame.size.height, self.shareView.frame.size.width, self.shareView.frame.size.height);
            }];
        }];
        
        self.currentPosition = PositionCenter;

    } else if (self.currentPosition == PositionCenter) {
        self.shareView.image = self.imageView.image;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.shareView.frame = CGRectMake(SidePadding, self.imageView.frame.size.height - self.shareView.frame.size.height, self.shareView.frame.size.width, self.shareView.frame.size.height);
            CALayer * layer = self.imageView.layer;
            layer.zPosition = -4000;
            CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
            rotationAndPerspectiveTransform.m34 = 1.0 / -300;
            layer.shadowOpacity = 0.01;
            layer.transform = CATransform3DRotate(rotationAndPerspectiveTransform, 10.0f * M_PI / 180.0f, 1.0f, 1.0f, 0.0f);
            
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.2 animations:^{
                self.imageView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
                self.imageView.alpha = 0.5;
            } completion:^(BOOL finished){
                
            }];
        }];
        self.currentPosition = PositionShare;
    }
}

- (IBAction)save:(id)sender {
    NSLog(@"Save");
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil, nil);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setImage:(UIImage *)image {
    _image = image;
}

@end

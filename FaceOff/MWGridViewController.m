//
//  MWGridViewController.m
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 08/10/2013.
//
//

#import "MWGridViewController.h"
#import "MWGridCell.h"
#import "WSAvatar.h"
#import "WSAvatarManager.h"
//#import "MWPhotoBrowserPrivate.h"
//#import "MWCommon.h"

@interface MWGridViewController () <UIAlertViewDelegate>
{
    
    // Store margins for current setup
    CGFloat _margin, _gutter, _marginL, _gutterL, _columns, _columnsL;
    NSInteger _currentSelectedIndex;
    UIToolbar * _toolbar;
    NSMutableArray * _selections;
    WSAvatarManager * _avatarManager;
}

@end

@implementation MWGridViewController 

- (id)init {
    if ((self = [super initWithCollectionViewLayout:[UICollectionViewFlowLayout new]])) {
        
        // Defaults
        _columns = 3, _columnsL = 4;
        _margin = 0, _gutter = 1;
        _marginL = 0, _gutterL = 1;
        
        // For pixel perfection...
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // iPad
            _columns = 6, _columnsL = 8;
            _margin = 1, _gutter = 2;
            _marginL = 1, _gutterL = 2;
        } else if ([UIScreen mainScreen].bounds.size.height == 480) {
            // iPhone 3.5 inch
            _columns = 5, _columnsL = 4;
            _margin = 0, _gutter = 1;
            _marginL = 1, _gutterL = 2;
        } else {
            // iPhone 4 inch
            _columns = 5, _columnsL = 5;
            _margin = 0, _gutter = 1;
            _marginL = 0, _gutterL = 2;
        }

        _initialContentOffset = CGPointMake(0, CGFLOAT_MAX);
        _currentSelectedIndex = 0;
        _selectionMode = YES;
 
    }
    return self;
}

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[MWGridCell class] forCellWithReuseIdentifier:@"GridCell"];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    NSInteger toolbarHeight = 44;
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - toolbarHeight, self.view.bounds.size.width, toolbarHeight)];
    //_toolbar.tintColor = [UIColor blackColor];
    //_toolbar.barTintColor = nil;
    _toolbar.barStyle = UIBarStyleDefault;
    [self.view addSubview:_toolbar];
    
    UIBarButtonItem * flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAvatars:)];
    UIBarButtonItem * promotionButton = [[UIBarButtonItem alloc] initWithTitle:@"Choosen pictures" style:UIBarButtonItemStylePlain target:nil action:nil];
    promotionButton.enabled = NO;
    
    NSMutableArray * items = [NSMutableArray array];
    //[items addObject:promotionButton];
    [items addObject:flexSpace];
    [items addObject:deleteButton];
    
    [_toolbar setItems:items];
    

    
    _selections = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!_avatarManager) {
        _avatarManager = [[WSAvatarManager alloc] init];
    } else {
        
    }
    
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAvatar:)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationController.navigationItem.title = @"头像管理";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    for (int i = 0; i < _avatarManager.avatars.count; i++) {
        [_selections addObject:[NSNumber numberWithBool:NO]];
    }
}

- (IBAction)deleteAvatars:(id)sender {
    NSLog(@"delete avatars");
    
    if ([self selectedCellCount] == 0) {
        return;
    }
    NSString * promoteMessage = [NSString stringWithFormat:@"将要删除 %ld 个头像?", (long)([self selectedCellCount])];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:promoteMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alertView show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            return;
            break;
        case 1:
        {
            for (int i = (int)_avatarManager.avatars.count - 1; i >= 0; i--) {
                if ([self cellIsSelectedAtIndex:i]) {
                    [_avatarManager removeObjectAtIndex:i];
                    [_selections removeObjectAtIndex:i];
                    [self.collectionView reloadData];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)addAvatar:(id)sender {
    NSLog(@"add new avatar");
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    
        //_imagePicker
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"finish picking");
    NSData * imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerEditedImage"], 1);
    UIImage * selectedImage = [UIImage imageWithData:imageData];
    CGFloat width = MIN(selectedImage.size.width, selectedImage.size.height);
    CGFloat x = (selectedImage.size.width - width) / 2;
    CGFloat y = (selectedImage.size.height - width) / 2;
    CGRect cropRect = CGRectMake(x, y, width, width);

    CGImageRef imageRef = CGImageCreateWithImageInRect([selectedImage CGImage], cropRect);
    UIImage * cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [_avatarManager addAvatar:UIImageJPEGRepresentation(cropped, 1.0f)];
        [_selections addObject:[NSNumber numberWithBool:NO]];
        [self.collectionView reloadData];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {


    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self performLayout];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)adjustOffsetsAsRequired {
    
    // Move to previous content offset
    if (_initialContentOffset.y != CGFLOAT_MAX) {
        self.collectionView.contentOffset = _initialContentOffset;
        [self.collectionView layoutIfNeeded]; // Layout after content offset change
    }
    
    // Check if current item is visible and if not, make it so!
    //if (_browser.numberOfPhotos > 0) {
    if (_avatarManager.avatars.count > 0) {
        //NSIndexPath *currentPhotoIndexPath = [NSIndexPath indexPathForItem:_browser.currentIndex inSection:0];
        NSIndexPath *currentPhotoIndexPath = [NSIndexPath indexPathForItem:_currentSelectedIndex inSection:0];

        NSArray *visibleIndexPaths = [self.collectionView indexPathsForVisibleItems];
        BOOL currentVisible = NO;
        for (NSIndexPath *indexPath in visibleIndexPaths) {
            if ([indexPath isEqual:currentPhotoIndexPath]) {
                currentVisible = YES;
                break;
            }
        }
        if (!currentVisible) {
            [self.collectionView scrollToItemAtIndexPath:currentPhotoIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }
    
}

- (void)performLayout {
    UINavigationBar *navBar = self.navigationController.navigationBar;
    self.collectionView.contentInset = UIEdgeInsetsMake(navBar.frame.origin.y + navBar.frame.size.height + [self getGutter], 0, 0, 0);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.collectionView reloadData];
    [self performLayout]; // needed for iOS 5 & 6
}

#pragma mark - Layout

- (CGFloat)getColumns {
        return _columns;
}

- (CGFloat)getMargin {
        return _margin;
}

- (CGFloat)getGutter {
        return _gutter;
}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    //return [_browser numberOfPhotos];
    return [_avatarManager.avatars count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell for index %ld", (long)indexPath.row);
    MWGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[MWGridCell alloc] init];
    }
    //id <MWPhoto> photo = [_browser thumbPhotoAtIndex:indexPath.row];
    //id <MWPhoto> photo = [MWPhoto photoWithImage:_photos[indexPath.row]];
    WSAvatar * avatar = _avatarManager.avatars[indexPath.row];
    UIImage * photo = [UIImage imageNamed:avatar.imageName];
    cell.photo = photo;
    cell.gridController = self;
    cell.selectionMode = _selectionMode;
    cell.isSelected = [self cellIsSelectedAtIndex:indexPath.row];
    cell.index = indexPath.row;
    if (photo) {
        [cell displayImage];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _currentSelectedIndex = indexPath.row;
 }

- (NSInteger) selectedCellCount {
    NSInteger count = 0;
    
    for (NSNumber * number in _selections) {
        if ([number boolValue]) {
            count = count + 1;
        }
    }
    
    return count;
}

- (void)setCellSelected:(BOOL)selected atIndex:(NSUInteger)index {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
    //_toolbar.it
}

- (BOOL)cellIsSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //[((MWGridCell *)cell).photo cancelAnyLoading];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat margin = [self getMargin];
    CGFloat gutter = [self getGutter];
    CGFloat columns = [self getColumns];
    CGFloat value = floorf(((self.view.bounds.size.width - (columns - 1) * gutter - 2 * margin) / columns));
    return CGSizeMake(value, value);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return [self getGutter];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return [self getGutter];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat margin = [self getMargin];
    return UIEdgeInsetsMake(margin, margin, margin, margin);
}

@end

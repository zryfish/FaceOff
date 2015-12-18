//
//  WSAvatarCollectionViewController.m
//  FaceOff
//
//  Created by ZRY on 15/12/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import "WSAvatarCollectionViewController.h"
#import "WSAvatarManager.h"
#import "WSMenuItemCell.h"
#import "WSAvatar.h"

@interface WSAvatarCollectionViewController ()

@property (strong, nonatomic) WSAvatarManager * avatarManager;

@end

@implementation WSAvatarCollectionViewController

static NSString * const reuseIdentifier = @"WSMenuItemCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.avatarManager = [[WSAvatarManager alloc] init];

    
    // Register cell classes
    UINib * cellNib = [UINib nibWithNibName:@"WSMenuItemCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[WSMenuItemCell class] forSupplementaryViewOfKind:@"title" withReuseIdentifier:@"WSMenuItemCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //self.collectionView.contentInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    //self.collectionViewLayout
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    //[self.navigationController.navigationBar]
    UIBarButtonItem * addAvatarBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAvatar:)];
    self.navigationItem.rightBarButtonItem = addAvatarBarItem;
    self.navigationItem.title = @"头像管理";
}

- (IBAction)addAvatar:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.avatarManager.avatars count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WSMenuItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    WSAvatar * avatar = self.avatarManager.avatars[indexPath.row];
    //UIImageView * imageView = (UIImageView *)[cell viewWithTag:100];
    
    cell.imageView.image = [UIImage imageNamed:avatar.imageName];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //WSMenuItemCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    WSAvatar * avatar = self.avatarManager.avatars[indexPath.row];
    NSLog(@"select %@", avatar.imageName);
}


// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    WSMenuItemCell * cell = (WSMenuItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    //cell.imageView.layer.opacity = 0.8f;
    //cell.imageView.layer.borderColor = [UIColor blueColor].CGColor;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    WSMenuItemCell * cell = (WSMenuItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    //cell.imageView.layer.opacity = 1.0f;
}

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}


@end

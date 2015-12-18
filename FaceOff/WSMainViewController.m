//
//  WSMainViewController.m
//  FaceOff
//
//  Created by ZRY on 15/12/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import "WSMainViewController.h"
#import "WSEditorViewController.h"
#import "WSAvatarCollectionViewController.h"
#import "WSAvatarManager.h"
#import "MWGridViewController.h"
#import "WSAvatar.h"
#import "WSAboutViewController.h"

@interface WSMainViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>

//@property (strong, nonatomic) WSAvatarManager * avatarManager;
@property (strong, nonatomic) NSMutableArray * photos;

@end

@implementation WSMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"MainViewHasLanuchedOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MainViewHasLanuchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"First time lanuch");
        NSIndexPath * path = [NSIndexPath indexPathForRow:1 inSection:1];
        
        [self tableView:self.tableView didSelectRowAtIndexPath:path];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 3;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSLog(@"%ld", (long)indexPath.row);
    
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"选择一张微信聊天截图";
    } else {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"头像管理";
                break;
            case 1:
                cell.textLabel.text = @"如何使用";
                break;
            case 2:
                cell.textLabel.text = @"关于";
                break;
                
            default:
                break;
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"功能";
    } else {
        return @"其它";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select row at %ld", indexPath.row);
    if (indexPath.section == 0) {
        
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    } else {
        switch (indexPath.row) {
            case 0:
                NSLog(@"select row of second section at index 0");
            {
                
                
                /*MWPhotoBrowser * browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
                
                browser.displayActionButton = YES;
                browser.displayNavArrows = NO;
                browser.displaySelectionButtons = YES;
                browser.enableGrid = YES;
                browser.startOnGrid = YES;
                browser.alwaysShowControls = YES;
                
                [browser setCurrentPhotoIndex:1];*/
                MWGridViewController * browser = [[MWGridViewController alloc] init];
                //browser.photos = self.photos;
                
                [self.navigationController pushViewController:browser animated:YES];
            }
                break;
            case 1:
            {
                WSAboutViewController * howToUseViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WSAboutViewController"];
                howToUseViewController.url = @"HowToUse";
                [self.navigationController pushViewController:howToUseViewController animated:YES];
            }
                break;
            case 2:
            {
                WSAboutViewController * aboutViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WSAboutViewController"];
                aboutViewController.url = @"About";
                [self.navigationController pushViewController:aboutViewController animated:YES];
                
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSData * dataImage = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 1);
    
    UIImage * selectedImage = [[UIImage alloc] initWithData:dataImage];
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    if (fcmp(scale, 3.0f)) {
        //scale /= 1.15f;
    }
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width * scale;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height * scale;
    
    NSLog(@"%f %f", selectedImage.size.width, selectedImage.size.height);
    
    if (!(fcmp(screenWidth, selectedImage.size.width) && fcmp(screenHeight, selectedImage.size.height))) {
        [picker dismissViewControllerAnimated:YES completion:^{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"看起来不像是一张微信聊天截图" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
        }];
        return;
    }
    
    
    WSEditorViewController * editorView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditorView"];
    editorView.image = selectedImage;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:editorView animated:YES completion:nil];
    }];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

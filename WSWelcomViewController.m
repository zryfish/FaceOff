//
//  FOWelcomViewController.m
//  FaceOff
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import "WSWelcomViewController.h"
#import "WSEditorViewController.h"

@interface WSWelcomViewController() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//@property (weak, nonatomic) IBOutlet UIBarButtonItem *chooseImageBtn;
//
//@property (strong, nonatomic) WSEditorViewController * editorViewController;
//@property (strong, nonatomic) UIImagePickerController * imagePicker;

//@property (strong, nonatomic) UIImage* selectedImage;

@end

@implementation WSWelcomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.editorViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditorView"];
    //self.editorViewController = [[WSEditorViewController alloc] init];
}

/*- (IBAction)chooseImageBtnClick:(id)sender {
    //[self.navigationController pushViewController:self.editorViewController animated:YES];
    if (!self.imagePicker) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    
    [self presentViewController:self.imagePicker animated:YES completion:^{
        NSLog(@"Pop up image picker");
    }];
    //self.editorViewController.test.text = @"Come on baby";
    //self.editorViewController.image = [UIImage imageNamed:@"1.pic_hd.jpg"];
    //[self.navigationController pushViewController:self.editorViewController animated:YES];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSData * dataImage = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 1);
    
    UIImage * selectedImage = [[UIImage alloc] initWithData:dataImage];
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:^{
        //FOEditorViewController * editorViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditorView"];
        //editorViewController.test.text = [@"Come on, baby" copy];
        self.editorViewController.image = [selectedImage copy];
        //[editorViewController setImage:selectedImage];
        
        [self.navigationController pushViewController:self.editorViewController animated:YES];
    }];
}*/


@end

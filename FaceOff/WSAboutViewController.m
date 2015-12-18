//
//  WSAboutViewController.m
//  FaceOff
//
//  Created by ZRY on 15/12/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import "WSAboutViewController.h"

@interface WSAboutViewController()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WSAboutViewController

- (void)viewDidLoad {
    //self.webView.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.bounds.size.height, self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height);
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:self.url ofType:@"html"] isDirectory:NO]]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    UIViewController * vc = [[self.navigationController viewControllers] firstObject];
    
    if ([vc isEqual:self]) {
        NSLog(@"Navigation Bar exists");
        
    }
}

@end

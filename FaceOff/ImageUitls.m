//
//  ImageUitls.m
//  FaceOff
//
//  Created by ZRY on 15/12/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import "ImageUitls.h"

@implementation ImageUitls

+ (UIImage *)drawText:(NSString *)text onImage:(UIImage *)image atPoint:(CGPoint)point {
    UIFont * font = [UIFont fontWithName:@"Courier" size:36];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    [text drawInRect:rect withAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:font, NSFontAttributeName, nil] ];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

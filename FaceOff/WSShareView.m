//
//  WSShareView.m
//  FaceOff
//
//  Created by ZRY on 15/12/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#import "WSShareView.h"
#import "OpenShareHeader.h"

@interface WSShareView()

@property (strong, nonatomic) NSDictionary * icons;

@end

@implementation WSShareView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self commonInit];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor whiteColor];
        [self commonInit];
    }
    return self;
}

-(void)commonInit {
    UIColor * blue = [UIColor blueColor];
    
    self.icons = @{@"pengyouquan"   : @"\U0000e610",
                   @"weixin"        : @"\U0000e60a",
                   //@"qq"            : @"\U000f001d",
                   //@"qzone"         : @"\U0000e71b",
                   //@"weibo"         : @"\U000f000a",
                   };
    
    int i = 0;
    int buttonWidth = SCREEN_WIDTH / self.icons.count - 20;
    if (buttonWidth > 50) {
        buttonWidth = 50;
    }
    
    float fromX = SCREEN_WIDTH / 2 - self.icons.count * (buttonWidth + 25) / 2;
    if (fromX < 0) {
        fromX = 0;
    }
    
    for (NSString * icon in @[@"weixin", @"pengyouquan"/*, @"weibo",  @"qq", @"qzone"*/]) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = buttonWidth / 2;
        btn.clipsToBounds = YES;
        btn.frame = CGRectMake(fromX + i * (buttonWidth + 25), MARGIN_TOP + 10, buttonWidth, buttonWidth);
        btn.layer.borderColor = blue.CGColor;
        btn.layer.borderWidth = 1;
        [btn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self imageWithColor:blue] forState:UIControlStateSelected];
        [btn setTitleColor:blue forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:buttonWidth / 1.5];
        [btn setTitle:self.icons[icon] forState:UIControlStateNormal];
        [self addSubview:btn];
        
        UILabel * label = [[UILabel alloc] init];
        
        label.text = icon;
        label.frame = CGRectMake(fromX + i * (buttonWidth + 15), MARGIN_TOP + 10 + buttonWidth + 5, buttonWidth, buttonWidth / 2);
        [label adjustsFontSizeToFitWidth];
        //[self addSubview:label];
        
        i++;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        
        
    }
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(IBAction)btnClicked:(UIButton *)sender {
    NSLog(@"button clicked");
    //[self removeFromSuperview];
    OSMessage * msg = [[OSMessage alloc] init];
    msg.title = @"Hello FaceOff";
    msg.image = self.image;
    switch (sender.tag) {
        case 1:
            [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
                //ULog(@"share to weixin session: \n %@", message);
            } Fail:^(OSMessage *message, NSError *error) {
                //ULog(@"share to weixin session: \n %@ \n %@", error, message);
            }];
            break;
            
        case 2:
            NSLog(@"share to wechat timeline");
            //OSMessage * msg = [[OSMessage alloc] init];
            [self shareToWeixinTimeLine];
            break;
        case 3:
            //NSLog(@"%ld", sender.tag);
            [OpenShare shareToWeibo:msg Success:^(OSMessage * message){
                //ULog(@"share to weibo: \n %@", message);
            }Fail:^(OSMessage *message, NSError *error) {
                //ULog(@"share to weibo: \n %@ \n %@", error, message);
            }];
            break;
        case 4:
            [OpenShare shareToQQFriends:msg Success:^(OSMessage *message) {
                //ULog(@"share to QQ: \n %@", message);
            } Fail:^(OSMessage *message, NSError *error) {
                //
                ULog(@"share to QQ: \n %@ \n %@", error, message);
            }];
            break;
        case 5:
            [OpenShare shareToQQZone:msg Success:^(OSMessage *message) {
                //ULog(@"share to QQ Zone: \n %@", message);
            } Fail:^(OSMessage *message, NSError *error) {
                //NSLog(@"share to QQ Zone: \n %@ \n %@", error, message);
            }];
            break;
        
        default:
            break;
    }
}

- (void)shareToWeixinTimeLine
{
    OSMessage * msg = [[OSMessage alloc] init];
    msg.title = @"Hello FaceOff";
    msg.image = self.image;
    [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
        //ULog(@"share to weixin timeline:\n %@", message);
    } Fail:^(OSMessage *message, NSError *error) {
        //ULog(@"share to weixin timeline:\n %@ \n %@", error, message);
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

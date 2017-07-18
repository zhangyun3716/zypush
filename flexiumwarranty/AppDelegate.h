//
//  AppDelegate.h
//  flexiumwarranty
//
//  Created by flexium on 2016/11/10.
//  Copyright © 2016年 FLEXium. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *appKey = @"dfaab3f49ad54c94027d93a4";
static NSString *channel = @"b0d6018a381f1fd04d486637";
static BOOL isProduction = true;
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UILabel *_infoLabel;
    UILabel *_tokenLabel;
    UILabel *_udidLabel;
}

@property(retain, nonatomic) UIWindow *window;



@end


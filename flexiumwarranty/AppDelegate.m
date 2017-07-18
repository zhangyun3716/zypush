//  AppDelegate.m
//  flexiumwarranty
//  Created by flexium on 2016/11/10.
//  Copyright © 2016年 FLEXium. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LoginViewController.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#import <AudioToolbox/AudioToolbox.h>
@interface AppDelegate ()<JPUSHRegisterDelegate,UIAlertViewDelegate>

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor grayColor]];
    [UIApplication sharedApplication].applicationIconBadgeNumber  =  0;
    
    //--------------集成极光推送-------------------alias
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:nil
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    // -----------------------------------
    
//    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ViewController *mevc=[sb instantiateInitialViewController];
//     self.window.rootViewController =[[UINavigationController alloc]initWithRootViewController:mevc];
//进入登录界面
    self.window.rootViewController =[[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
    [self.window makeKeyAndVisible];
//使用Safari打开界面网络
//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    return YES;
}

//--------------集成极光推送-------------------
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required -    DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
// Required,For systems with less than or equal to iOS6
- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSLog(@"%@",content);
    NSNotification *notification = [NSNotification notificationWithName:@"Notice" object:nil userInfo:userInfo[@"aps"]];
    //此通知将推送内容发送给其他界面，如不需要，可以不写
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {  //此时app在前台运行，我的做法是弹出一个alert，告诉用户有一条推送，用户可以选择查看或者忽略
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"推送消息"
                                                         message:@"您有一条新的推送消息!"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"查看",nil];
        AudioServicesPlaySystemSound(1307);
        //        NSURL *url = [ [ NSURL alloc ] initWithString: @"https://www.pgyer.com/baoxiu" ];
        //        [[UIApplication sharedApplication] openURL:url];
        [alert show];
        
        
    }
    
    else  if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
        //这里是app未运行或者在后台，通过点击手机通知栏的推送消息打开app时可以在这里进行处理，比如，拿到推送里的内容或者附加      字段(假设，推送里附加了一个url为 www.baidu.com)，那么你就可以拿到这个url，然后进行跳转到相应店web页，当然，不一定必须是web页，也可以是你app里的任意一个controll，跳转的话用navigation或者模态视图都可以
        NSLog(@"ggggg");
        
        //告诉他要去通知了
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PassValueWithNotification" object:nil];
    }else{//告诉他要去通知了
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PassValueWithNotification" object:nil];
    }
    
    //这里设置app的图片的角标为0，红色但角标就会消失
    [UIApplication sharedApplication].applicationIconBadgeNumber  =  0;
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    // NSLog(@"%@",userInfo);
    
    
}
//ios推送点了来干嘛
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
//    [JPUSHService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
     NSDictionary *aps = [userInfo valueForKey:@"aps"];
      NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
     NSLog(@"%@",content);
      NSNotification *notification = [NSNotification notificationWithName:@"Notice" object:nil userInfo:userInfo[@"aps"]];
    //此通知将推送内容发送给其他界面，如不需要，可以不写
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    completionHandler(UIBackgroundFetchResultNewData);
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {  //此时app在前台运行，我的做法是弹出一个alert，告诉用户有一条推送，用户可以选择查看或者忽略
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"推送消息"
                                                         message:@"您有一条新的推送消息!"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"查看",nil];
        AudioServicesPlaySystemSound(1307);
//        NSURL *url = [ [ NSURL alloc ] initWithString: @"https://www.pgyer.com/baoxiu" ];
//        [[UIApplication sharedApplication] openURL:url];
        [alert show];
  
        
    }
    
    else  if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
        //这里是app未运行或者在后台，通过点击手机通知栏的推送消息打开app时可以在这里进行处理，比如，拿到推送里的内容或者附加      字段(假设，推送里附加了一个url为 www.baidu.com)，那么你就可以拿到这个url，然后进行跳转到相应店web页，当然，不一定必须是web页，也可以是你app里的任意一个controll，跳转的话用navigation或者模态视图都可以
        NSLog(@"ggggg");
        
        //告诉他要去通知了
         [[NSNotificationCenter defaultCenter] postNotificationName:@"PassValueWithNotification" object:nil];
    }else{//告诉他要去通知了
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PassValueWithNotification" object:nil];
    }
    
    //这里设置app的图片的角标为0，红色但角标就会消失
    [UIApplication sharedApplication].applicationIconBadgeNumber  =  0;
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    // NSLog(@"%@",userInfo);
  

}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSString* msg = [[NSString alloc] initWithFormat:@"您按下的第%ld个按钮！",(long)buttonIndex];
//    NSLog(@"%@",msg);
    if(buttonIndex==1){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PassValueWithNotification" object:nil];
    }
}
//程序关闭后点击会执行这个方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    completionHandler();  // 系统要求执行这个方法
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"CommentViewController dealloc");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PassValueWithNotification" object:nil];
}

@end

//
//  LoginViewController.m
//  flexiumwarranty
//
//  Created by flexium on 2016/11/10.
//  Copyright © 2016年 FLEXium. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import "ZYScannerView.h"
@interface LoginViewController ()
- (IBAction)beginscan:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *scanbtn;
@property (strong, nonatomic) NSString *usertype;

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;//上方标题栏
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fn=[[paths objectAtIndex:0]stringByAppendingPathComponent:@"zhongwu.plist"];
    NSString *fg=[[paths objectAtIndex:0]stringByAppendingPathComponent:@"zhixun.plist"];
    NSFileManager *fm=[NSFileManager defaultManager];
     if ([fm fileExistsAtPath:fn]||[fm fileExistsAtPath:fg]) {
    if ([fm fileExistsAtPath:fn]) {
        _usertype=@"user";
    }else{
        _usertype=@"inquiry";
    }
     }else{
         UIButton *kunshanbtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-90, 255, 180, 45)];
         [kunshanbtn setTitle:@"总务" forState:UIControlStateNormal];
         [kunshanbtn setBackgroundColor:[UIColor lightGrayColor]];
         [kunshanbtn addTarget:self action:@selector(chosezhongwu) forControlEvents:UIControlEventTouchUpInside];
         [self.view addSubview:kunshanbtn];
         UIButton *gaoxiongbtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-90, 335, 180, 45)];
         [gaoxiongbtn setTitle:@"资讯" forState:UIControlStateNormal];
         [gaoxiongbtn addTarget:self action:@selector(chosezhixun) forControlEvents:UIControlEventTouchUpInside];
         [gaoxiongbtn setBackgroundColor:[UIColor lightGrayColor]];
         [self.view addSubview:gaoxiongbtn];
     }
    self.scanbtn.layer.cornerRadius=8;//裁成圆角
    self.scanbtn.layer.masksToBounds=YES;//隐藏裁剪掉的部分
  
}

#pragma mark 隐藏状态栏
-(BOOL)prefersStatusBarHidden{
    return YES;
}
#pragma mark 开始扫描
- (IBAction)beginscan:(UIButton *)sender {
    if (_usertype.length<2) {
        [self tixing];
    }else{
    [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
        NSString *message=str;
        UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *mevc=[sb instantiateInitialViewController];
        mevc.usertype=_usertype;
         mevc.emp_no=message;
        //將用戶存入userdefaults  user為使用用戶tuishong為推送用戶
        [[NSUserDefaults standardUserDefaults] setValue:_usertype forKey: @"user"];
        NSString *tuishong=@"";
        if ([_usertype isEqualToString:@"user"]) {
            tuishong=@"inquiry";
        }else{
            tuishong=@"user";
        }
        [[NSUserDefaults standardUserDefaults] setValue:tuishong forKey: @"tuishong"];
        [self presentViewController:mevc animated:YES completion:nil];
        
    }];
    }
}
#pragma mark 选择了总务的方法
-(void)chosezhongwu{
    NSLog(@"選擇了总务");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fn = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"zhongwu.plist"];
    NSDictionary *dic = @{@"isFirstLaunch":@1};
    [dic writeToFile:fn atomically:YES];
     _usertype=@"user";
    [self querenxuanzhi];
}
#pragma mark 选择了资讯的方法
-(void)chosezhixun{
    NSLog(@"選擇了资讯");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fn = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"zhixun.plist"];
    NSDictionary *dic = @{@"isFirstLaunch":@1};
    [dic writeToFile:fn atomically:YES];
    _usertype=@"inquiry";
    [self querenxuanzhi];
}
-(void)tixing{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择用户" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"请选择用户"];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 5)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 5)];
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    [cancelAction setValue:[UIColor blueColor] forKey:@"titleTextColor"];
}
-(void)querenxuanzhi{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"选择成功"];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 4)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 4)];
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    [cancelAction setValue:[UIColor blueColor] forKey:@"titleTextColor"];
}
@end

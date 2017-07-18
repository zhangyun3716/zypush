
/********佛祖镇楼********BUG没有*********\
 *	_________         __       __      *
 * |______  /         \ \     / /      *
 *       / /           \ \   / /       *
 *      / /             \ \ / /        *
 *     / /               \   /         *
 *    / /                 | |          *
 *   / /                  | |          *
 *  / /_________          | |          *
 * /____________|         |_|          *
 \******佛祖镇楼********BUG没有**********/
/*Copyright (c) 2011 ~ 2015 zhangyun. All rights reserved.
 */
//NSString *yonghu=[[NSUserDefaults standardUserDefaults] valueForKey:@"user"];
//NSString *tuishong=[[NSUserDefaults standardUserDefaults] valueForKey:@"tuishong"]

#import "ViewController.h"
#import "ZYScannerView.h"
#import "JPUSHService.h"
#import <AudioToolbox/AudioToolbox.h>  
#import "RecordsViewController.h"
@interface ViewController ()<UITextViewDelegate,NSXMLParserDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *text;
@property (strong,nonatomic)UILabel *uilabel;
- (IBAction)beginwarranty:(UIButton *)sender;
//确定报修
@property (strong, nonatomic) IBOutlet UIButton *beginwarranty;
@property (strong, nonatomic) IBOutlet UILabel *emplable;
//选择报修类型
- (IBAction)Chooseleixing:(UIButton *)sender;
//扫描锁或卡机
- (IBAction)Scanbaoxiu:(UIButton *)sender;
//物品编号
@property (strong, nonatomic) IBOutlet UILabel *wupingnum;
//物品类型
@property (strong, nonatomic) IBOutlet UILabel *wupingtype;
//地区数组
@property (strong,nonatomic) NSArray *AreaArray;

//pickerView的定义显示
@property (nonatomic,strong) UIView * secondview;
@property (nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic,copy)NSString *arestr;
@property (strong, nonatomic) IBOutlet UIView *pickbackview;

//通知相关内容
@property (strong,nonatomic) NSString *messagestr;

//菊花界面
@property (strong,nonatomic)UIActivityIndicatorView *testview;

//报修记录
- (IBAction)records:(UIButton *)sender;
//用戶部門
@property (strong, nonatomic) IBOutlet UILabel *emp_type;

@end

@implementation ViewController
#pragma mark 界面即将出现
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;//上方标题栏
}

//摇晃手机
-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [self canBecomeFirstResponder];
}
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
//    NSLog(@"开始摇晃");
    
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if(motion == UIEventSubtypeMotionShake){
        NSLog(@"Shake!!!!!!!!!!!");
        AudioServicesPlaySystemSound(1307);
        [self gotomessage];
    }
}

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
}

#pragma mark 界面出现中
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:@"Notice" object:nil];
    // 注册观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotomessage) name:@"PassValueWithNotification" object:nil];
    
    [JPUSHService setAlias:_usertype callbackSelector:@selector(tagsAliasCallback) object:nil];
    _appKey=@"dfaab3f49ad54c94027d93a4";
    _MasterSecret=@"b0d6018a381f1fd04d486637";
    [UIApplication sharedApplication].applicationIconBadgeNumber  =  0;
    _emplable.text=_emp_no;
    _uilabel=[[UILabel alloc]init];
    self.beginwarranty.layer.cornerRadius=10;//裁成圆角
    self.beginwarranty.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    _text.hidden=NO;
    _text.delegate=self;
    _uilabel.frame =CGRectMake(0, 8, _text.bounds.size.width, 20);
    _uilabel.text = @"报修备注";
    _uilabel.textColor=[UIColor blackColor];
    _uilabel.enabled = NO;//lable必须设置为不可用
    _uilabel.backgroundColor = [UIColor clearColor];
    //用戶類型
 //   NSString *yonghu=[[NSUserDefaults standardUserDefaults] valueForKey:@"user"];
    NSString *yonghu=@"";
    if ([_usertype isEqualToString:@"user"]) {
        yonghu=@"總務部";
    }else{
        yonghu=@"資訊部";
    }
    _emp_type.text=yonghu;
    [_text addSubview:_uilabel];
    _text.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    _text.layer.borderWidth=1.0f;
    _text.textColor=[UIColor blackColor];
    _text.backgroundColor=[UIColor whiteColor];
    _text.alpha=1;
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];

    
}
#pragma mark 获取推送内容
-(void)notice:(NSNotification *)userInfo{
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = userInfo.userInfo;
    NSString *string = dic[@"alert"];
    _messagestr=string;
    
}
#pragma mark 通知执行的方法进入界面实现方法
-(void)gotomessage{
    NSLog(@"通知内容：%@",_messagestr);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"通知内容" message:_messagestr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)tagsAliasCallback{
    NSLog(@"加油加油加油加油");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark 点击报修
- (IBAction)beginwarranty:(UIButton *)sender {
    UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    testActivityIndicator.backgroundColor=[UIColor blackColor];
    testActivityIndicator.center = CGPointMake(100.0f, 100.0f);//只能设置中心，不能设置大小
    [testActivityIndicator setFrame :CGRectMake(100, 200, 100, 100)];//不建议这样设置，因为
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor whiteColor]; // 改变圈圈的颜色为红色； iOS5引入
    [testActivityIndicator startAnimating]; // 开始旋转
    self.testview=testActivityIndicator;
    NSData *nsdata = [@"dfaab3f49ad54c94027d93a4:b0d6018a381f1fd04d486637"
                      dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    NSLog(@"%@",base64Encoded);
    NSNumber *n3=[NSNumber numberWithBool:NO];
    NSNumber *n1=  [NSNumber numberWithInteger:3210];
    NSNumber *n2=[NSNumber numberWithInteger:120];
   //  NSNumber *n4=[NSNumber numberWithInteger:4];
    NSString *messagetext=self.text.text;
    NSString *str=[NSString stringWithFormat:@"basic %@",base64Encoded];
    NSString *path = @"https://api.jpush.cn/v3/push" ;
    NSString *tuishongtype=@"";
    if ([_usertype  isEqualToString:@"user"]) {
        tuishongtype=@"inquiry";
    }else{
        tuishongtype=@"user";
    }
    NSDictionary *params=@{
                  @"Authorization":str,
                  @"platform": @"all",
                  @"audience": @{@"alias":@[tuishongtype]},
                  @"notification": @{
                      @"ios": @{
                          @"alert": messagetext,
                          @"sound": @"default",
                          @"badge": @"1",
                          @"extras": @{
                              @"newsid": n1
                          }
                      }
                  },
                  @"options": @{
                      @"time_to_live": n2,
                      @"apns_production": n3
                  }
                  };
   NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:str forHTTPHeaderField:@"Authorization"];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"response---------%@",response);
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"str--------%@",str);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
        NSLog(@"dic -------%@",dic);
         dispatch_async(dispatch_get_main_queue(), ^{
        self.text.text=@"";
             [self tixingmessage ];
                 [testActivityIndicator stopAnimating]; // 结束旋转
                 [testActivityIndicator removeFromSuperview]; //当旋转结束时移除
         });
    }];
    [task resume];
    
}
#pragma mark 提醒界面
-(void)tixingmessage{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"报修成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"报修成功"];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 4)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 4)];
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    [cancelAction setValue:[UIColor blueColor] forKey:@"titleTextColor"];
}
#pragma mark 报修备注界面后面的按钮显示
-(void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length == 0) {
        _uilabel.text = @"报修备注";
    }else{
        _uilabel.text = @"";
    }
}

#pragma mark 键盘高度监控出现
- (void)keyboardWasShown:(NSNotification*)aNotification

{
    self.pickerView.backgroundColor=[UIColor blueColor];
    //键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"%f",keyBoardFrame.size.width);
    self.pickbackview.frame=CGRectMake(40,self.view.frame.size.width-keyBoardFrame.size.height+117, 240, 130);
    
    
}

#pragma mark 键盘即将消失
-(void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    self.pickbackview.frame=CGRectMake(40, 367, 240, 130);
    
}

#pragma mark 清除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark 选择报修类型的方法
- (IBAction)Chooseleixing:(UIButton *)sender {
    self.secondview =[[UIView alloc]initWithFrame:self.view.frame];
    self.pickerView =[[UIPickerView alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 500)];
    self.pickerView.dataSource=self;
    self.pickerView.delegate=self;
    [self.pickerView selectRow:1 inComponent:0 animated:YES];
    [self.secondview addSubview:self.pickerView];
    [self.view addSubview:self.secondview];
    self.secondview.backgroundColor=[UIColor whiteColor];
    UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-50, self.view.bounds.size.height-70, 100, 50)];
    //[btn1 setBackgroundColor:[UIColor lightGrayColor]];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"normal1.png"] forState:UIControlStateNormal];
    [btn1 setTitle:@"確認" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.secondview addSubview:btn1];
    btn1.layer.cornerRadius=7;//裁成圆角
    btn1.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    [btn1 addTarget:self action:@selector(SureChoose) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 懒加载报修类型分类
-(NSArray *)AreaArray{
    if (_AreaArray==nil) {
        _AreaArray=[[NSArray alloc]init];
        _AreaArray=@[@"門鎖",@"餐卡機",@"三閘機",@"其他"];
    }
    return _AreaArray;
}
#pragma mark 确认选择按钮
-(void)SureChoose{
    self.secondview.hidden=YES;
    [self.secondview removeFromSuperview];
}

#pragma mark  看看有多少行
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
#pragma mark 控件部分有多少行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.AreaArray.count;
}
#pragma mark 每行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30.0f;
}
#pragma mark 宽度设定就是类型选择的界面
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 200;
}
#pragma mark 类型选择每行显示什么东西
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString  *str=self.AreaArray[row];
    return str;
}
#pragma mark row的东西界面
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *mycom1 = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 30.0f)];
    [mycom1 setTextAlignment:NSTextAlignmentCenter];
    mycom1.textColor=[UIColor blackColor];
    NSString *imgstr1 = self.AreaArray[row];
    mycom1.text = imgstr1;
    [mycom1 setFont:[UIFont systemFontOfSize: 18]];
    mycom1.backgroundColor = [UIColor whiteColor];
    return mycom1;
}
#pragma mark 选择方法物品类型选择的
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _wupingtype.text= self.AreaArray[row] ;
    _wupingtype.textColor=[UIColor redColor];
    _arestr=self.AreaArray[row];
}

#pragma mark 开始扫描锁或者卡机
- (IBAction)Scanbaoxiu:(UIButton *)sender {
    [[ZYScannerView sharedScannerView] showOnView:self.view block:^(NSString *str) {
        self.wupingnum.text=str;
    }];
}

#pragma mark 点击进入报修记录
- (IBAction)records:(UIButton *)sender {
    RecordsViewController *rvc=[[RecordsViewController alloc]init];
    [self presentViewController:rvc animated:YES completion:nil];
}
//还需要请求网络数据然后请求完进行报修动作
@end

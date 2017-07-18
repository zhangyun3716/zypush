//  baoxiuxiangqingViewController.m
//  flexiumwarranty
//  Created by flexium on 2016/11/28.
//  Copyright © 2016年 FLEXium. All rights reserved.

#import "baoxiuxiangqingViewController.h"
#import "CommentCell.h"
#import  "ComentModel.h"
#import "BXXQCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
//#import <IQKeyboardManager.h>
//键盘
#import "BCKeyBoard.h"
#define MY_GRAYCOLOR [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1.00]
#define BXCELLId @"BXXQCell"
#define COMMENtCEllID @"ComementCell"
@interface baoxiuxiangqingViewController ()<UITableViewDelegate,UITableViewDataSource,BCKeyBoardDelegate>
@property (nonatomic,strong)UITableView *tableview;
//@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataSource;
//@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property (nonatomic, assign) CGFloat history_Y_offset;
@property (nonatomic,copy)NSIndexPath *currentIndexPath;
@property (nonatomic,strong)BCKeyBoard *bc;
@property (nonatomic,strong) CommentCell *cell2;

- (IBAction)goback:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *jiedanbtn;
@property (strong, nonatomic) IBOutlet UIButton *querenbtn;

@end

@implementation baoxiuxiangqingViewController

-(void)viewWillAppear:(BOOL)animated{
    [self buildkeyBoard];
    [self qingqiushuju];
    
}
#pragma mark 界面加載界面設定
- (void)viewDidLoad {
    [super viewDidLoad];
    self.querenbtn.layer.cornerRadius=7;//裁剪出圆角
    self.querenbtn.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height-200)];
    [self.view addSubview:self.tableview];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.backgroundColor=[UIColor whiteColor];
    self.tableview.separatorStyle=UITableViewCellAccessoryNone;
    [self.tableview   setSeparatorColor:[UIColor    whiteColor]];  //设置分割线为蓝色
    self.tableview.tableFooterView=[[UIView alloc]init];
    self.tableview.bounces=NO;
    //评论详情
    [self.tableview registerClass:[CommentCell class] forCellReuseIdentifier:COMMENtCEllID];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gogo)];
    tap.cancelsTouchesInView =NO;
    [self.tableview addGestureRecognizer:tap];
    [self.bc endEditing:YES];
    self.tableview.estimatedRowHeight = 1000;  //  随便设个不那么离谱的值
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    
}
#pragma mark 建立鍵盤
-(void)buildkeyBoard{
    NSArray *array = @[@"chatBar_colorMore_photoSelected",@"chatBar_colorMore_audioCall",@"chatBar_colorMore_location",@"chatBar_colorMore_video.png",@"chatBar_colorMore_video.png",@"chatBar_colorMore_video.png"];
    BCKeyBoard *bc = [[BCKeyBoard alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height-90,self.view.bounds.size.width,  46)];
    self.bc=bc;
    bc.delegate = self;
    bc.imageArray = array;
    bc.placeholder=[NSString stringWithFormat:@"评论:zhongwu"];
   bc.currentCtr = self;
    bc.placeholderColor = [UIColor colorWithRed:133/255 green:133/255 blue:133/255 alpha:0.5];
    bc.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bc];
     dispatch_async(dispatch_get_main_queue(), ^{
    [bc bringSubviewToFront:self.view];
         [self.bc endEditing:YES];
         
     });
}
#pragma mark 发送消息
- (void)didSendText:(NSString *)text
    {
        ComentModel *model = [ComentModel new];
        model.name =  @"总务部：";//名字也有
        model.CommentText =text;
        [_CommentmodelArray addObject:model];
        [self.tableview reloadData];
        [self TellCell:nil];
        NSLog(@"短信內容：%@",text);
}
#pragma mark 返回高度
- (void)returnHeight:(CGFloat)height
{
    NSLog(@"%f",height);
}
#pragma mark 返回圖片
- (void)returnImage:(UIImage *)image{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    imageView.image = image;
    [self.view addSubview:imageView];
}
#pragma mark 告訴cell
-(void)TellCell:(NSNotification *)notification{
    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow: (int)self.CommentmodelArray.count-1 inSection:1]atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
#pragma mark 发送通知
-(void)gogo{
    //NSLog(@"这地方隐藏拉伸上来的键盘");
    [self.bc endEditing:YES];
}
#pragma mark 拖拽tableview隐藏键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.bc endEditing:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.bc endEditing:YES];
    //告诉他要做隐藏键盘了
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Hidethekeyboard" object:nil];
}
#pragma mark 隐藏状态栏
-(BOOL)prefersStatusBarHidden{
    return YES;
}
#pragma mark 返回分組
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.CommentmodelArray.count==0) {
        return 1;
    }
    else{
        return 2;
    }
}
#pragma mark 每組返回行數
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(self.CommentmodelArray.count ==0){
        
        return 1;
    }else{
        if (section==0) {
            return 1;
        }
        else {
            return  self.CommentmodelArray.count;
        }
    }
}
#pragma mark 每行的內容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     BXXQCell *cell1=[tableView dequeueReusableCellWithIdentifier:BXCELLId];
   if (cell1 ==nil) {
    cell1=[[[NSBundle mainBundle]loadNibNamed:@"BXXQCell" owner:nil options:nil]objectAtIndex:0];

    }
if (_CommentmodelArray.count!=0) {
    CommentCell *cell2=[tableView dequeueReusableCellWithIdentifier:COMMENtCEllID];
    _cell2=cell2;
}
   if(indexPath.section==0){
        cell1.backgroundColor=[UIColor whiteColor];
        [cell1.wentimiaoshu setEditable:NO];
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell1.wupingbianhao.text=@"11111";
        return cell1;
    }

    else if(indexPath.section==1){
        _cell2.model =self.CommentmodelArray[indexPath.row];
        return _cell2;
    }
    else{
        return nil;
    }
}


#pragma mark cell高度的返回
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
#pragma mark  >>>>>>>>>>>>>>>>>>>>> * cell高度自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
    {
    if(self.CommentmodelArray.count ==0){
    return 167;
    }
else    {
    if (indexPath.section==0&&self.CommentmodelArray.count !=0) {
        return 167;
    }
    else {
        id model =self.CommentmodelArray[indexPath.row];
        CGFloat h =  [self.tableview cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CommentCell class] contentViewWidth:[self cellContentViewWith]];
            return h;
    }
}

}

#pragma mark 返回
- (IBAction)goback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 清除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"CommentViewController dealloc");
}
#pragma mark 请求数据
-(void)qingqiushuju{
    _CommentmodelArray=[[NSMutableArray alloc]init];
    for (int i = 0; i < 5; i++) {
        ComentModel *model = [ComentModel new];
        model.name =  @"资讯部：";//名字也有
        model.CommentText =[NSString stringWithFormat:@"%d报修已经修好了，但是不好啊还要解析加油修理",i];
        [_CommentmodelArray addObject:model];
    }

}
@end

//
//  RecordsViewController.m
//  flexiumwarranty
//
//  Created by flexium on 2016/11/25.
//  Copyright © 2016年 FLEXium. All rights reserved.
//

#import "RecordsViewController.h"
#import "informationcell.h"
#define CEll1 @"CELL1"
#import "baoxiuxiangqingViewController.h"
@interface RecordsViewController ()<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)goback:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *fanhuibtn;

@end

@implementation RecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.backgroundColor=[UIColor whiteColor];
    //隐藏下方多余的分割线。
    self.tableview.tableFooterView=[[UIView alloc] init];
    self.fanhuibtn.layer.cornerRadius=7;//裁剪出圆角
    self.fanhuibtn.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;

//    //下列方法的作用也是隐藏分割线。
//    [self.tableview setSeparatorInset:UIEdgeInsetsZero];
//    [self.tableview setLayoutMargins:UIEdgeInsetsZero];
    //头部不可选择
//    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    // self.tableview.bounces=NO;
    // 设置tableview的cell可以自动计算高度；
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark 返回行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
#pragma mark 每行显示什么东西
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    informationcell *cell1=[tableView dequeueReusableCellWithIdentifier:CEll1];
    if (cell1 ==nil) {
        cell1=[[[NSBundle mainBundle]loadNibNamed:@"informationcell" owner:nil options:nil]objectAtIndex:0];
        cell1.contentView.backgroundColor=[UIColor whiteColor];
        cell1.backgroundColor=[UIColor whiteColor];
    }
    cell1.Itemnum.text=[ NSString stringWithFormat:@"%ld",(long)indexPath.row];
    cell1.Itemnum.layer.borderWidth=0.5f;
    cell1.Itemnum.layer.borderColor=[[UIColor blackColor] CGColor];
    cell1.Serialnum.layer.borderWidth=0.5f;
    cell1.Serialnum.layer.borderColor=[[UIColor blackColor] CGColor];
    cell1.Repaittime.layer.borderWidth=0.5f;
    cell1.Repaittime.layer.borderColor=[[UIColor blackColor] CGColor];
    cell1.Repaitstate.layer.borderWidth=0.5f;
    cell1.Repaitstate.layer.borderColor=[[UIColor blackColor] CGColor];
    return cell1;
    
}
#pragma mark 分组头显示的内容
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    UILabel *lable1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 54, 50)];
    UILabel *lable2=[[UILabel alloc]initWithFrame:CGRectMake(53, 0, 113, 50)];
    UILabel *lable3=[[UILabel alloc]initWithFrame:CGRectMake(166, 0, 97, 50)];
    UILabel *lable4=[[UILabel alloc]initWithFrame:CGRectMake(263, 0, 57, 50)];
    [view addSubview:lable1];
    [view addSubview:lable2];
    [view addSubview:lable3];
    [view addSubview:lable4];
    lable1.layer.borderWidth=0.5f;
    lable1.layer.borderColor=[[UIColor blackColor] CGColor];
    lable2.layer.borderWidth=0.5f;
    lable2.layer.borderColor=[[UIColor blackColor] CGColor];
    lable3.layer.borderWidth=0.5f;
    lable3.layer.borderColor=[[UIColor blackColor] CGColor];
    lable4.layer.borderWidth=0.5f;
    lable4.layer.borderColor=[[UIColor blackColor] CGColor];
    lable1.text=@"序號";
    [lable1 setTextAlignment:NSTextAlignmentCenter];
    lable1.textColor=[UIColor blackColor];
    lable2.text=@"物品編號";
    [lable2 setTextAlignment:NSTextAlignmentCenter];
    lable2.textColor=[UIColor blackColor];
    lable3.text=@"報修時間";
    [lable3 setTextAlignment:NSTextAlignmentCenter];
    lable3.textColor=[UIColor blackColor];
    lable4.text=@"處理狀態";
    [lable4 setTextAlignment:NSTextAlignmentCenter];
    lable4.textColor=[UIColor blackColor];
    // view.backgroundColor=[UIColor whiteColor];
    lable1.font=[UIFont systemFontOfSize:14];
    lable2.font=[UIFont systemFontOfSize:14];
    lable3.font=[UIFont systemFontOfSize:14];
    lable4.font=[UIFont systemFontOfSize:12];
    view.backgroundColor=[UIColor lightGrayColor];
    return view;
}
#pragma mark 分组头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
    
}
#pragma mark 返回行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark 返回按钮
- (IBAction)goback:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 推送进入其他界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    baoxiuxiangqingViewController *baoxiuvc=[[baoxiuxiangqingViewController alloc]init];
    [self presentViewController:baoxiuvc animated:YES completion:nil];
}
@end

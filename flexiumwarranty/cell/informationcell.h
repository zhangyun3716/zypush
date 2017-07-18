//
//  informationcell.h
//  saptest
//
//  Created by flexium on 2016/10/28.
//  Copyright © 2016年 FLEXium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface informationcell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *Serialnum;

@property (strong, nonatomic) IBOutlet UILabel *Itemnum;
@property (strong, nonatomic) IBOutlet UILabel *Repaittime;
@property (strong, nonatomic) IBOutlet UILabel *Repaitstate;

@end

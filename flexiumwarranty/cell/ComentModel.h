//
//  ComentModel.h
//  违章查询
//
//  Created by Administrator on 16/6/15.
//  Copyright © 2016年 zhangyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComentModel : NSObject
//评论用户的id
//@property(nonatomic,copy)NSString *userID;
//评论的用户的图像
//@property (nonatomic, copy) NSString *iconName;
//评论用户的名字
@property (nonatomic, copy) NSString *name;
//评论的内容
@property (nonatomic, copy) NSString *CommentText;
@end

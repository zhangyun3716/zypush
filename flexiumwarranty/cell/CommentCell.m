//
//  CommentCell.m
//  违章查询
//
//  Created by Administrator on 16/6/15.
//  Copyright © 2016年 zhangyun. All rights reserved.
//

#import "CommentCell.h"
#import "ComentModel.h"
#import "UIView+SDAutoLayout.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
@interface CommentCell ()
@property (nonatomic, strong) UILabel *contentLabel;
@end
#define FONT_COLOR [UIColor colorWithRed:0.59 green:0.60 blue:0.60 alpha:1.00]
@implementation CommentCell
{
//    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_contentLabel;
   }
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
//设置每个块的位置
- (void)setup
{
//    self.bounds.size.height
//   _iconView = [UIImageView new];
    _nameLable = [UILabel new];
//    _nameLable.backgroundColor=[UIColor orangeColor];
    _nameLable.font = [UIFont systemFontOfSize:15];
    _nameLable.textColor = [UIColor blackColor];
    _nameLable.numberOfLines=0;
    _contentLabel = [UILabel new];
    _contentLabel.numberOfLines=0;
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.backgroundColor=[UIColor whiteColor];
    _contentLabel.textColor = [UIColor blackColor];//FONT_COLOR;
    NSArray *views = @[ _nameLable, _contentLabel];//@[_iconView, _nameLable, _contentLabel];
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];

    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
//    _iconView.sd_layout
//    .leftSpaceToView(contentView, margin+40)
//    .topSpaceToView(contentView, margin + 15)
//    .widthIs(40)
//    .heightIs(40);
    
    _nameLable.sd_layout
    .leftSpaceToView(contentView, margin+13)
    .topSpaceToView(contentView,margin)
    .autoHeightRatio(0)//heightIs(13)
    .widthIs(60)
    ;
   [_nameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    _contentLabel.sd_layout
    .leftSpaceToView(_nameLable,5)
    .topSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, 10)
    .autoHeightRatio(0);
    [self setupAutoHeightWithBottomView:_contentLabel bottomMargin:margin];
}

//设置每个地方显示什么东东哦
- (void)setModel:(ComentModel *)model
{
    _model = model;
//    _iconView.image = [UIImage imageNamed:model.iconName];
//     [_iconView sd_setImageWithURL:[NSURL URLWithString:model.iconName]];//缓存头像照片
    _nameLable.text = model.name;
    //_nameLable.textColor=[UIColor redColor];
    _contentLabel.text = model.CommentText;
   // _contentLabel.textColor=[UIColor redColor];

}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:NO animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:NO animated:animated];
}


@end

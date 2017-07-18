//
//  BCKeyBoard.m
//  BCDemo
//
//  Created by baochao on 15/7/27.
//  Copyright (c) 2015年 baochao. All rights reserved.
//

#import "BCKeyBoard.h"
#import "BCTextView.h"
#import "Const.h"
#import "DXFaceView.h"
#import "BCMoreView.h"

@interface BCKeyBoard () <UITextViewDelegate,DXFaceDelegate,UINavigationControllerDelegate,UIPrinterPickerControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong)UIImageView *backgroundImageView;
@property (nonatomic,strong)UIButton *faceBtn;
@property (nonatomic,strong)UIButton *moreBtn;
@property (nonatomic,strong)BCTextView  *textView;
@property (nonatomic,strong)UIView *faceView;
@property (nonatomic,assign)BOOL isTop;
@property (nonatomic,strong)UIView *moreView;
@property (nonatomic,assign)CGFloat lastHeight;
//拓展的view
@property (nonatomic,strong)UIView *activeView;
@end

@implementation BCKeyBoard
- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kBCTextViewHeight)) {
        frame.size.height = kVerticalPadding * 2 + kBCTextViewHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kBCTextViewHeight)) {
        frame.size.height = kVerticalPadding * 2 + kBCTextViewHeight;
    }
    [super setFrame:frame];
}
- (void)createUI
{
    _lastHeight = 30;
    //注册键盘改变是调用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    // 注册观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboarddeay:) name:@"Hidethekeyboard" object:nil];
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backgroundImageView.userInteractionEnabled = YES;
    self.backgroundImageView.image = [[UIImage imageNamed:@"messageToolbarBg"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:10];
    
    
    //表情按钮
    self.faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.faceBtn.frame = CGRectMake(kHorizontalPadding,kHorizontalPadding, 30, 30);
    [self.faceBtn addTarget:self action:@selector(willShowFaceView:) forControlEvents:UIControlEventTouchUpInside];
    [self.faceBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_face"] forState:UIControlStateNormal];
    [self.faceBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    [self addSubview:self.faceBtn];
    
    //文本
    self.textView = [[BCTextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.faceBtn.frame)+kHorizontalPadding, kHorizontalPadding, self.bounds.size.width - 4*kHorizontalPadding -30, 30)];
    self.textView.placeholderColor = self.placeholderColor;
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.scrollEnabled = NO;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    self.textView.layer.borderWidth = 0.65f;
    self.textView.layer.cornerRadius = 6.0f;
    [self.textView becomeFirstResponder];
    self.textView.delegate = self;
    
    //textview里面没有文字发送按钮不可用;
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.enablesReturnKeyAutomatically = YES;
    //更多按钮
    self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame)+kHorizontalPadding,kHorizontalPadding,30,30);
    [self.moreBtn addTarget:self action:@selector(willShowactiveView:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_more"] forState:UIControlStateNormal];
    [self.moreBtn setBackgroundImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    self.moreBtn.hidden=YES;
    [self addSubview:self.backgroundImageView];
    [self.backgroundImageView addSubview:self.textView];
    [self.backgroundImageView addSubview:self.faceBtn];
    [self.backgroundImageView addSubview:self.moreBtn];
    
    if (!self.faceView) {
        self.faceView = [[DXFaceView alloc] initWithFrame:CGRectMake(0, (kHorizontalPadding * 2 + 30), self.frame.size.width, 200)];
        [(DXFaceView *)self.faceView setDelegate:self];
        self.faceView.backgroundColor = [UIColor whiteColor];
        self.faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    if (!self.moreView) {
        self.moreView = [[BCMoreView alloc] initWithFrame:CGRectMake(0, (kHorizontalPadding * 2 + 30), self.frame.size.width, 200)];
        self.moreView.backgroundColor = [UIColor whiteColor];
        self.moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
}

/**
 改变高度
 */
- (void)changeFrame:(CGFloat)height{
    
    if (height == _lastHeight)
    {
        return;
    }
    else{
        CGFloat changeHeight = height - _lastHeight;//+64///////////
        
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        rect = self.backgroundImageView.frame;
        rect.size.height += changeHeight;
        self.backgroundImageView.frame = rect;
        
        
        [self.textView setContentOffset:CGPointMake(0.0f, (self.textView.contentSize.height - self.textView.frame.size.height) / 2) animated:YES];
        
        CGRect frame = self.textView.frame;
        frame.size.height = height;
        self.textView.frame = frame;
        
        _lastHeight = height;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(returnHeight:)]) {
            [self.delegate returnHeight:height];
        }
    }

}
- (void)setPlaceholder:(NSString *)placeholder
{
    self.textView.placeholder = placeholder;
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    self.textView.placeholderColor = placeholderColor;
}
//键盘出来改变键盘的高度
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    void(^animations)() = ^{
        CGRect frame = self.frame;
        //
        frame.origin.y = endFrame.origin.y - self.bounds.size.height;//-64; 这是点击按钮上弹高度
        self.frame = frame;
    };
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
    //键盘出现通知cell要准备到最后一行了
//     [[NSNotificationCenter defaultCenter] postNotificationName:@"TellCellGo" object:nil];
    
}
-(void)keyboarddeay:(NSNotification *  )notification{
    NSDictionary *userInfo = notification.userInfo;
//    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    void(^animations)() = ^{
        CGRect frame = self.frame;
        //
        frame.origin.y = self.window.bounds.size.height-44;//-114这里是按钮消失返回的高度
        self.frame = frame;
    };
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
}

#pragma mark 表情View
//表情view即将显示
- (void)willShowFaceView:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if(btn.selected == YES){
        [self willShowBottomView:self.faceView];
        //键盘获取焦点
        [self.textView resignFirstResponder];
    }else{
        [self willShowBottomView:nil];
        [self.textView becomeFirstResponder];
    }
}

#pragma mark 表更多View
//表情view即将显示
- (void)willShowactiveView:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if(btn.selected == YES){
        [self willShowBottomView:self.moreView];
        //失去焦点
        [self.textView resignFirstResponder];
        [(BCMoreView *)self.moreView setImageArray:self.imageArray];
    }else{
        [self willShowBottomView:nil];
        //获取焦点
        [self.textView becomeFirstResponder];
    }
}
//每个表情的高度
- (void)willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.backgroundImageView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    self.frame = toFrame;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(returnHeight:)]) {
        [self.delegate returnHeight:toHeight];
    }
}
- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    //返回高度
    return ceilf([textView sizeThatFits:textView.frame.size].height+54);////////+64
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self willShowBottomView:nil];
    self.faceBtn.selected = NO;
    self.moreBtn.selected = NO;
}
//键盘出现的高度
- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self willShowBottomHeight:toFrame.size.height];
        if (self.activeView) {
            [self.activeView removeFromSuperview];
        }
        self.activeView = nil;
    }
    else if(toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self willShowBottomHeight:0];
    }
    else{
        [self willShowBottomHeight:toFrame.size.height];
    }
}
//键盘你给老子消失吧
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:textView.text];
            self.textView.text = @"";
            [self changeFrame:ceilf([textView sizeThatFits:textView.frame.size].height)];
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"PassValueWithNotification" object:nil];
            [self keyboarddeay:nil];
          [self.textView endEditing:YES];
            
        }
        return NO;
    }
    return YES;
}
//将要显示button的view
- (void)willShowBottomView:(UIView *)bottomView
{
    if (![self.activeView isEqual:bottomView]) {
        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
        [self willShowBottomHeight:bottomHeight];
        
        if (bottomView) {
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.backgroundImageView.frame);
            bottomView.frame = rect;
            [self addSubview:bottomView];
        }
        if (self.activeView) {
            [self.activeView removeFromSuperview];
        }
        self.activeView = bottomView;
    }
}
//文字的改变的监听
- (void)textViewDidChange:(UITextView *)textView
{
    [self changeFrame:ceilf([textView sizeThatFits:textView.frame.size].height)];
}
- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete
{
    NSString *chatText = self.textView.text;
    
    if (!isDelete && str.length > 0) {
        self.textView.text = [NSString stringWithFormat:@"%@%@",chatText,str];
    }
    else {
        if (chatText.length >= 2)
        {
            NSString *subStr = [chatText substringFromIndex:chatText.length-2];
            if ([(DXFaceView *)self.faceView stringIsFace:subStr]) {
                self.textView.text = [chatText substringToIndex:chatText.length-2];
                [self textViewDidChange:self.textView];
                return;
            }
        }
        if (chatText.length > 0) {
            self.textView.text = [chatText substringToIndex:chatText.length-1];
        }
    }
    [self textViewDidChange:self.textView];
}
//表情的发送按钮
- (void)sendFace
{
    NSString *chatText = self.textView.text;
    if (chatText.length > 0) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:chatText];
            self.textView.text = @"";
            [self changeFrame:ceilf([self.textView sizeThatFits:self.textView.frame.size].height)];
        }
    }
    [self keyboarddeay:nil];
}

- (void)openCamera{
    //打开系统相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.currentCtr presentViewController:picker animated:YES completion:nil];
    }
}
//图片的选择
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if([self.delegate respondsToSelector:@selector(returnImage:)]){
        [self.delegate returnImage:image];
    }
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self.currentCtr dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.currentCtr dismissViewControllerAnimated:YES completion:nil];
}
- (void)openLibary{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.currentCtr presentViewController:picker animated:YES completion:nil];
        }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Hidethekeyboard" object:nil];
}
@end

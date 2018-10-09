//
//  ViewController.m
//  TYCopyIvarDemo
//
//  Created by 马天野 on 2018/10/10.
//  Copyright © 2018 Maty. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 一般正常改变 TextField 的占位文字颜色
//    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入姓名:" attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
    
    // 使用 runtime API 修改
    self.textField.placeholder = @"请输入姓名:";
    // 查看其所有的成员变量
    unsigned int count;
    Ivar *ivars = class_copyIvarList([UITextField class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"%s %s",ivar_getName(ivar), ivar_getTypeEncoding(ivar));
    }
    
    // 打印出UITextField 这个类的所有成员变量了, _placeholderLabel 找到这个成员变量
    // 通过 kvc 根据成员变量取出这个 label
    UILabel *placeholderLabel = [self.textField valueForKeyPath:@"_placeholderLabel"];
    placeholderLabel.textColor = [UIColor blueColor];
    
    // 或者下面的写法
    [self.textField setValue:[UIColor orangeColor] forKeyPath:@"_placeholderLabel.textColor"];
}


@end

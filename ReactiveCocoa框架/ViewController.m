//
//  ViewController.m
//  ReactiveCocoa框架
//
//  Created by apple on 15/10/18.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

#import "ReactiveCocoa.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 当两个文本框同时有内容的时候,按钮才允许点击
//    [_textField1.rac_textSignal subscribeNext:^(id x) {
//       
//        NSLog(@"%@",x);
//    }];
//    
//    [_textField2.rac_textSignal subscribeNext:^(id x) {
//        
//        NSLog(@"%@",x);
//    }];
    
    // 第一个参数:就是存放需要合并信号
    [[RACSignal combineLatest:@[_textField1.rac_textSignal,_textField2.rac_textSignal] reduce:^id(NSString *str1,NSString *str2){
        NSLog(@"%@ ---- %@",str1,str2);
        // block:只要任意一个信号发出内容,就会调用
        // block参数个数:由信号决定
        // block参数类型:block的参数就是信号发出值
        // 把两个信号中的值聚合成哪个值
        return @(str1.length && str2.length);
    }] subscribeNext:^(id x) {
        _btn.enabled = [x boolValue];
        NSLog(@"%@",x);
    }];
    
}

- (void)zipWith
{
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    
    RACSignal *signals = [signalA zipWith:signalB];
    
    [signals subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // zipWith:当两个信号都发出内容的时候,才能被订阅到
    [signalA sendNext:@1];
    [signalB sendNext:@2];
    
    [signalB sendNext:@3];
    [signalA sendNext:@4];

}

- (void)merge
{
    // merge:合并,任何一个信号只要发送值,就能订阅
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    
    RACSignal *signals = [signalA merge:signalB];
    
    [signals subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [signalA sendNext:@1];
    
    [signalB sendNext:@2];
    
    [signalB sendNext:@3];

}

- (void)then
{
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    
    // 组合
    RACSignal *signals = [signalA then:^RACSignal *{
        return signalB;
    }];
    
    [signals subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [signalA sendNext:@1];
    [signalA sendCompleted];
    [signalB sendNext:@2];
    // then跟concat区别:监听不到第一个信号的值,共同点都是必须第一个信号完成,第二个信号才会激活
}

- (void)concat
{
    // concat:连接信号,有顺序的拼接,一定要等第一个信号完成的时候,第二个信号才会被激活
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    
    // 组合信号
    RACSignal *signals = [signalA concat:signalB];
    
    // 订阅组合信号
    [signals subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 发送数据
    [signalA sendNext:@1];
    [signalA sendCompleted];
    [signalB sendNext:@2];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

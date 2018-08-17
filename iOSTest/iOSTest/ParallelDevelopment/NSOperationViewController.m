//
//  NSOperationViewController.m
//  iOSTest
//
//  Created by lilong on 2018/8/17.
//  Copyright © 2018年 lilong. All rights reserved.
//

#import "NSOperationViewController.h"

@interface NSOperationViewController ()
{
    UIImageView *_imageView;
}
@end

@implementation NSOperationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI1];
}

#pragma mark 界面布局
-(void)layoutUI1{
    _imageView =[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    _imageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(50, 500, 220, 25);
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    //添加方法
    [button addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


#pragma mark 多线程下载图片
-(void)loadImageWithMultiThread{
    //创建一个调用操作
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImage) object:nil];
    //创建完NSInvocationOperation对象并不会自动调用，它是由一个start方法启动操作，但是注意如果直接调用start方法，则此操作会在主线中调用，一般不会这么操作，而是添加到NSOperationQueue中
//    [invocationOperation start];
    
    //创建操作队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //注意添加到操作队列后，队列会开启一个线程执行此操作
    [queue addOperation:invocationOperation];
}


#pragma mark 加载图片
-(void)loadImage{
    NSLog(@"%@",[NSThread currentThread]);
    
    //请求数据
    NSData *data= [self requestData];
    /*将数据显示到UI控件,注意只能在主线程中更新UI,
     另外performSelectorOnMainThread方法是NSObject的分类方法，每个NSObject对象都有此方法，
     它调用的selector方法是当前调用控件的方法，例如使用UIImageView调用的时候selector就是UIImageView的方法
     Object：代表调用方法的参数,不过只能传递一个参数(如果有多个参数请使用对象进行封装)
     waitUntilDone:当前线程是否要被阻塞，直到主线程将我们指定的代码块(updateImage)执行完。
     注意：当前线程为主线程的时候，waitUntilDone:YES参数无效。
     */
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:data waitUntilDone:YES];
}

#pragma mark 请求图片数据
-(NSData *)requestData{
    NSURL *url=[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534501084870&di=1ab4b1a4209e5342118ebc2074374be6&imgtype=0&src=http%3A%2F%2Fpic2.zhimg.com%2Fv2-3efa478d973dbaa2d8c4f098cf107724_1200x500.jpg"];
    NSData *data=[NSData dataWithContentsOfURL:url];
    return data;
}

#pragma mark 将图片显示到界面
-(void)updateImage:(NSData *)imageData{
    UIImage *image=[UIImage imageWithData:imageData];
    _imageView.image=image;
}


@end

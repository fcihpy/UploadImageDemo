//
//  ViewController.m
//  UploadImageDemo
//
//  Created by zhisheshe on 15/7/16.
//  Copyright (c) 2015年 firstChedai. All rights reserved.
//

#import "ViewController.h"
#import "FCImageHelper.h"

@interface ViewController ()<FCImageHelperDelegate>

{
    FCImageHelper *_imageHelper;
    NSInteger   _currenTag;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;

@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

@property (nonatomic,strong) NSMutableArray *imageArry;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)pickImage:(UIButton *)sender {
    
    _currenTag = sender.tag;

    _imageHelper = [FCImageHelper ImageHelper];
    _imageHelper.imagePickerDelelgate = self;
    
}


- (void)didFinishPickingImage:(UIImage *)image{
    

    switch (_currenTag) {
        case 1:
            self.imageView1.image = image;
            break;
        
        case 2:
            self.imageView2.image = image;
            break;
            
        case 3:
            self.imageView3.image = image;
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark 开始单张图片上传
- (IBAction)uploadImage:(UIButton *)sender {

    
    UIImage *uploadImage = nil;
    
    if (self.imageView1.image) {
        uploadImage = self.imageView1.image;
        
    }else if (self.imageView2.image){
         uploadImage = self.imageView2.image;
        
    }else if (self.imageView3.image){
        uploadImage = self.imageView3.image;
    }
    
    [FCImageHelper uploadImgWithImage:uploadImage success:^(NSString *message, NSString *imgUrlStr) {
        
//        NSLog(@"uploadImage %@--%@",message,imgUrlStr);
        
        //上传完成后，清空数组
        [self.imageArry removeAllObjects];
        
    } failure:^(NSError *error) {
        NSLog(@"uploadError %@",error.localizedDescription);
        
        //上传完成后，清空数组
        [self.imageArry removeAllObjects];
    }];
 
}


#pragma mark 开始多张图片上传
- (IBAction)uploadMutiImage:(UIButton *)sender {
    
    [self.imageArry addObject:self.imageView1.image];
    [self.imageArry addObject:self.imageView2.image];
    
    
//    if (self.imageView1.image) {
//        
//        [self.imageArry addObject:self.imageView1.image];
//        
//    }else if (self.imageView2.image){
//       
//        [self.imageArry addObject:self.imageView2.image];
//        
//    }else if (self.imageView3.image){
//       
//        [self.imageArry addObject:self.imageView3.image];
//        
//    }
    
    [FCImageHelper uploadImgWithImageArry:self.imageArry sucess:^(NSString *message, NSString *imgUrlStr) {
        
        NSLog(@"aseawet1111 %@",self.imageArry);
        [self.imageArry removeAllObjects];
        
    } failure:^(NSError *error) {
        
        [self.imageArry removeAllObjects];
    }];
    
}


- (NSArray *)imageArry{
    
    if (!_imageArry) {
        _imageArry = [NSMutableArray array];
    }
    return _imageArry;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  FCImageHelper.m
//  pinchehui
//
//  Created by zhisheshe on 15-6-3.
//  Copyright (c) 2015年 chepinzhidao. All rights reserved.
//

#import "FCImageHelper.h"
#import <UIKit/UIKit.h>
#import "UIImage+FC.h"
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>


#define UPLOADDSIGINIMAGE_URL @"http://appapi.pinchehui.com/api.php?c=common&a=upload"

#define UPLOADMUTILIMAGE_URL @"http://192.168.1.106/pinchehuitwo/img.pinchehui.com/home/index/d_up.html"


#define kPhotoString @"使用摄像头拍摄"
#define kCarmeraString @"从手机相册选择"
#define kCancleString @"取消"


@interface FCImageHelper ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate>

@property (nonatomic,strong) UIProgressView *progress;

@end


@implementation FCImageHelper

#pragma mark -init
- (id)init{
    if (self =[super init]) {
       
        [self presentActionSheet];
        
        
    }
    return self;
    
}

+ (instancetype)ImageHelper{
    
   return  [[self alloc]init];
}

#pragma mark -弹出ActionSheet
- (void)presentActionSheet{
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:kCancleString destructiveButtonTitle:nil otherButtonTitles:kPhotoString,kCarmeraString , nil];
    actionSheet.delegate= self;
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}



#pragma mark - 单张图片上传
+ (void)uploadImgWithImage:(UIImage *)image success:(uploadImageUrlSuccessBlock)success failure:(failureBlock)failure
{
    AFHTTPRequestOperation *operation = nil;
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
   operation =  [manager POST:UPLOADMUTILIMAGE_URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
       
        //把图片转为jpeg格式，同时压缩图片（0.0为最大压缩率，1.0为最小压缩率）
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        
        //上传参数
        [formData appendPartWithFileData:imageData name:@"iconImage" fileName:@"iconImage.jpg" mimeType:@"image/jpg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"单张图片上传 %@",responseObject);
        
        int errorNum = [responseObject[@"error"] intValue];
        
        if (errorNum == 0) {
            
            if (success) {
                success(responseObject[@"message"],[responseObject[@"list"][0] valueForKey:@"file_url"]);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"uploadimgerr %@",error.localizedDescription);
    }];
    
    //上传进度条
//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        NSLog(@"p8888888888888888-%lu,%lld,%lld",(unsigned long)bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
//        
//        UIView *keywindow = [UIApplication sharedApplication].keyWindow;
//        
//        float processValue = (totalBytesWritten*1.0/totalBytesExpectedToWrite) *100;
//        
//        NSLog(@"upload--process %f",processValue);
//        
//        UIProgressView *process = [[UIProgressView alloc]init];
//        process.frame = CGRectMake(50, 80,200, 40);
//        process.progressViewStyle = UIProgressViewStyleBar;
//        [process setProgress:processValue animated:YES];
////        process = nil;
//        [keywindow addSubview:process];
//        
//
//
//    }];

}



#pragma mark 多张图片上传
+ (void)uploadImgWithImageArry:(NSArray *)imageArry sucess:(void(^)(NSString *message,NSString *imgUrlStr))sucess failure:(failureBlock)failure{
    
    NSLog(@"aafawfet aryy %@",imageArry);
     AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    [manager POST:UPLOADMUTILIMAGE_URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        for (int i = 0 ; i < imageArry.count; i ++ ) {
            
            //对图片进行缩放
            CGSize scrallsize = CGSizeMake(320, 250);
            UIImage * scaleToSizeImg =[imageArry[i] scaleTosize:scrallsize];
            
            //1、转换图片为二进制数据
            NSData *imageData = UIImageJPEGRepresentation(scaleToSizeImg, 0.05);
            
            //2、拼接上传用的，保存在服务器上文件名
            //在网络开发中，上传文件时，文件名不允许被覆盖，可以在上传时把系统时间作为文件名的一部份进行拼接
            NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
            fmt.dateFormat = @"yyyyMMddHHmmss";
            NSString *timeStr = [fmt stringFromDate:[NSDate date]];
            
            NSString *fileName = [NSString stringWithFormat:@"iconImage%@.jpg",timeStr];
            
            //3、对应网站上可接收的字段参数；这里时files数组
            [formData appendPartWithFileData:imageData name:@"files[]" fileName:fileName mimeType:@"image/jpg"];
            
        }

        NSLog(@"formdata %@",formData);

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"uploadMutiimgRespone %@",responseObject);
        
        int errorNum = [responseObject[@"error"] intValue];
        
        if (errorNum == 0) {
            
            if (sucess) {
                sucess(responseObject[@"message"],responseObject[@"list"][0] [@"file_url"]);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
         NSLog(@"uploadimgerr %@",error.localizedDescription);
    }];
   
}



#pragma mark 图片缩放

//- (UIImage *)scaleWithImage:(UIImage *)image size:(CGSize)size{
//    
//    //创建图片上下文
//    UIGraphicsBeginImageContext(size);
//    
//    //绘制改变大小的图片
//    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    
//    //从context中创建一个改变大小后的图片
//    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    //使当前的context出堆栈
//    UIGraphicsEndImageContext();
//    
//    //返回新的改变后的图片
//    return scaleImage;
//}





// ----------------------------UIActionSheetDelegate----------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    
    @try {
        
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
        imgPicker.delegate = self;
        //编辑模式
        imgPicker.allowsEditing = YES;
        
        switch (buttonIndex) {
            case 0:             //使用摄像头拍摄
                imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
                
            case 1:              //从手机相册选择
                imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            default:
                return;
        }
        
        [self.imagePickerDelelgate presentViewController:imgPicker animated:YES completion:nil];
        
    }
    @catch (NSException *exception) {
        NSLog(@"您的机器不支持拍照");
    }
    @finally {
        
    }
}


- (void)willPresentActionSheet:(UIActionSheet *)actionSheet{
    
    for (UIView *view in actionSheet.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        }
    }
}


#pragma mark - -----------------------UINavigationControllerDelegate---------------------------

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated{
    
    [viewController.navigationItem setTitle:@"照片"];
    
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc ] initWithTitle:@"返回"
                                                                                        style:UIBarButtonItemStylePlain
                                                                                       target:self action:@selector(imageBack)];
    viewController.navigationItem.rightBarButtonItem=nil;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

#pragma mark - ------------------------UIImagePickerControllerDelegate----------------------


#pragma mark 选中相册
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * receiveImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    ;
    CGSize imageSize=receiveImage.size;
    
    receiveImage = [receiveImage scaleTosize:imageSize];
    
        NSData *imageData = UIImageJPEGRepresentation(receiveImage, 0.0001);
    
        UIImage *selectImage = [UIImage imageWithData:imageData];
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self.imagePickerDelelgate didFinishPickingImage:selectImage];
        
    }];
    
}


#pragma mark 取消相册
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imageBack {
    
    [self.imagePickerDelelgate dismissViewControllerAnimated:YES completion:nil];
    
    
}



@end



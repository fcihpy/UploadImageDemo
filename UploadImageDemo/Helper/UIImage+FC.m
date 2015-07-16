//
//  UIImage+FC.m
//  pinchehui
//
//  Created by zhisheshe on 15-3-16.
//  Copyright (c) 2015年 chepinzhidao. All rights reserved.
//

#import "UIImage+FC.h"

@implementation UIImage (FC)


#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName
{
    return [self resizedImage:imgName xPos:0.5 yPos:0.5];
}

+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos
{
    UIImage *image = [UIImage imageNamed:imgName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * xPos topCapHeight:image.size.height * yPos];
}



//+ (UIImage *)imageWithURL:(NSString *)url{
//    
//    UIImage *img = nil;
//    return  img;
//    NSURL *imgUrl = [NSURL URLWithString:url];
//    
//    [SDWebImageManager sharedManager] downloadWithURL:imgUrl options:SDWebImageLowPriority | SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//        img = image;
//    }
//
//}


#pragma mark 图片缩放
- (UIImage *)scaleTosize:(CGSize)size{
    
    //创建图片上下文
    UIGraphicsBeginImageContext(size);
    
    //绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //从context中创建一个改变大小后的图片
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    //返回新的改变后的图片
    return scaleImage;
}


@end

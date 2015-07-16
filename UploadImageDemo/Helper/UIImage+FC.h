//
//  UIImage+FC.h
//  pinchehui
//
//  Created by zhisheshe on 15-3-16.
//  Copyright (c) 2015年 chepinzhidao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FC)


#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName;


/**
    自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;


+ (UIImage *)imageWithURL:(NSString *)url;

/**
 图片缩放
 */
- (UIImage *)scaleTosize:(CGSize)size;



@end

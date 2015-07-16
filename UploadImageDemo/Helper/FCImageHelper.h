//
//  FCImageHelper.h
//  pinchehui
//
//  Created by zhisheshe on 15-6-3.
//  Copyright (c) 2015年 chepinzhidao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^successBlock)(NSString *message);
typedef void(^failureBlock)(NSError *error);
typedef void(^uploadImageUrlSuccessBlock)(NSString *message,NSString *imgUrlStr);

@protocol FCImageHelperDelegate <NSObject>

/**
    选中的图片
 */
- (void)didFinishPickingImage:(UIImage *)image;

@end


/**
 1、初始化变量，需要设置成全局的
 2、设置delegate
 3、加载presentActionSheet对象方法
 4、实现代理方法
 */

@interface FCImageHelper : NSObject


@property (nonatomic,assign) UIViewController<FCImageHelperDelegate>*imagePickerDelelgate;




+(instancetype)ImageHelper;


/**
    单张图片上传
*/

+ (void)uploadImgWithImage:(UIImage *)image success:(uploadImageUrlSuccessBlock)success failure:(failureBlock)failure;


/**
    多张图片上传
*/
+ (void)uploadImgWithImageArry:(NSArray *)imageArry sucess:(void(^)(NSString *message,NSString *imgUrlStr))sucess failure:(failureBlock)failure;



/**
    图片下载
*/



/**
    图片缩放
*/
//- (UIImage *)scaleWithImage:(UIImage *)image size:(CGSize)size;


/**
    清空图片缓存
*/


/**
 上传进度条
 */




@end

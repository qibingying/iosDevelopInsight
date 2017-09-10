//
//  SaveImage_Util.h
//  JavascriptCoreStudy
//
//  Created by shange on 2017/4/17.
//  Copyright © 2017年 jinshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SaveImage_Util : NSObject

#pragma mark  保存图片到document
+ (BOOL)saveImage:(UIImage *)saveImage ImageName:(NSString *)imageName back:(void(^)(NSString *imagePath))back;





@end

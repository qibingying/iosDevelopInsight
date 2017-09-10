//
//  SaveImage_Util.m
//  JavascriptCoreStudy
//
//  Created by shange on 2017/4/17.
//  Copyright © 2017年 jinshan. All rights reserved.
//

#import "SaveImage_Util.h"

@implementation SaveImage_Util

#pragma mark  保存图片到document
+ (BOOL)saveImage:(UIImage *)saveImage ImageName:(NSString *)imageName back:(void(^)(NSString *imagePath))back
{
    NSString *path = [SaveImage_Util getImageDocumentFolderPath];
    NSData *imageData = UIImagePNGRepresentation(saveImage);
    NSString *documentsDirectory = [NSString stringWithFormat:@"%@/", path];
    // Now we get the full path to the file
    NSString *imageFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //如果文件路径存在的话
    BOOL bRet = [fileManager fileExistsAtPath:imageFile];
    if (bRet)
    {
        //        NSLog(@"文件已存在");
        if ([fileManager removeItemAtPath:imageFile error:nil])
        {
            //            NSLog(@"删除文件成功");
            if ([imageData writeToFile:imageFile atomically:YES])
            {
                //                NSLog(@"保存文件成功");
                back(imageFile);
            }
        }
        else
        {
            
        }
    }
    else
    {
        if (![imageData writeToFile:imageFile atomically:NO])
        {
            [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
            if ([imageData writeToFile:imageFile atomically:YES])
            {
                back(imageFile);
            }
        }
        else
        {
            return YES;
        }
        
    }
    return NO;
}
#pragma mark  从文档目录下获取Documents路径
+ (NSString *)getImageDocumentFolderPath
{
    NSString *patchDocument = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [NSString stringWithFormat:@"%@/Images", patchDocument];
}












@end

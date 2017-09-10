//
//  GetImage.h
//  JavascriptCoreStudy
//
//  Created by shange on 2017/4/13.
//  Copyright © 2017年 jinshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSOCViewControllerExport <JSExport>

- (void)takePicture;

@end

@interface GetImage : NSObject

@property(nonatomic,strong) NSString *width;
@property(nonatomic,strong) NSString *height;




@end

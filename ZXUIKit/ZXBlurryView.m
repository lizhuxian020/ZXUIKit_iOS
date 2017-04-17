//
//  ZXBlurryView.m
//  ZXUIKit_example
//
//  Created by lzx on 17/4/17.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "ZXBlurryView.h"
#import <Accelerate/Accelerate.h>
#import <objc/runtime.h>

/**调到后台的背景view*/
static ZXBlurryView *appBlurryView = nil;

@implementation ZXBlurryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (void)load {
    [self observeNotification];
}

+ (void)observeNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

+ (void)didEnterBackground {
    
    if (appBlurryView == nil) {
        appBlurryView = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds blurryView:nil];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:appBlurryView];
}

+ (void)willEnterForeground {
    
    if (appBlurryView) {
        [appBlurryView removeFromSuperview];
        appBlurryView = nil;
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame blurryView:(UIView *)view {
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *currentImage = [self getCurrentImageWithView:view];
        if (currentImage) {
            UIImage *image = [UIImage imageWithData:UIImageJPEGRepresentation(currentImage, 1.)];
            UIImage *vImage = [self blurryImage:image withBlurLevel:.1];
            UIImageView *bgView = [[UIImageView alloc] initWithImage:vImage];
            bgView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
            [self addSubview:bgView];
        }
    }
    return self;
}

- (UIImage *)getCurrentImageWithView:(UIView *)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    }
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end

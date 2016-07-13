//
//  ViewController.m
//  ImageMaskSample
//
//  Created by fanjie on 7/13/16.
//  Copyright © 2016 jefferyfan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"apple.png"];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat y = (screenSize.height - image.size.height) / 2.f;
    CGFloat interval = (screenSize.width - 3 * image.size.width) / 4.f;
    
    UIImageView *imgView1 = [self imageViewWithSourceImage:image tintColor:[UIColor purpleColor]];
    imgView1.frame = (CGRect){CGPointMake(interval, y), imgView1.frame.size};
    [self.view addSubview:imgView1];
    
    UIImageView *imgView2 = [self imageViewWithSourceImage:image layerColor:[UIColor redColor]];
    imgView2.frame = (CGRect){CGPointMake(interval * 2 + image.size.width, y), imgView1.frame.size};
    [self.view addSubview:imgView2];
    
    UIImageView *imgView3 = [self imageViewWithSourceImage:image fillColor:[UIColor blackColor]];
    imgView3.frame = (CGRect){CGPointMake(interval * 3 + image.size.width * 2, y), imgView1.frame.size};
    [self.view addSubview:imgView3];
}

- (UIImageView *)imageViewWithSourceImage:(UIImage *)image tintColor:(UIColor *)color
{
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    CGRect frame = (CGRect){CGPointZero, image.size};;
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:frame] autorelease];
    imageView.tintColor = color;
    imageView.image = image;
    
    return imageView;
}

- (UIImageView *)imageViewWithSourceImage:(UIImage *)image layerColor:(UIColor *)color
{
    CGRect frame = (CGRect){CGPointZero, image.size};;
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:frame] autorelease];
    CALayer *layer = [CALayer layer];
    layer.frame = imageView.bounds;
    layer.contents = (id)image.CGImage;
    imageView.layer.mask = layer;
    imageView.backgroundColor = color;
    
    return imageView;
}

- (UIImageView *)imageViewWithSourceImage:(UIImage *)image fillColor:(UIColor *)color
{
    CGRect rect = (CGRect){CGPointZero, image.size};
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 由于坐标系不同，需要翻转Y坐标。如果不翻转Y坐标，则image上下颠倒。
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.f, -1.f);
    
    // 将后续的操作都限制到mask范围内
    CGContextClipToMask(context, rect, image.CGImage);
    
    // 填充颜色
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *sourceImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:rect] autorelease];
    imageView.image = sourceImage;
    
    return imageView;
}


@end

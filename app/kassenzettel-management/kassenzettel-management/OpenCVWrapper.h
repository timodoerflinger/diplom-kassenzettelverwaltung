//
//  OpenCVWrapper.h
//  OpenCImageStitching2
//
//  Created by Timo on 22.04.18.
//  Copyright © 2018 Timo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenCVWrapper : UIViewController

+(UIImage *) makeGrayFromImage:(UIImage *) image;

+(UIImage *) processImageThresholding:(UIImage *) image;

+(UIImage *) processPerspectiveTransformation:(UIImage *) image;


+ (UIImage*) processImageWithOpenCV: (UIImage*) inputImage;

+ (UIImage*) processWithOpenCVImage1:(UIImage*)inputImage1 image2:(UIImage*)inputImage2;

+ (UIImage*) processWithArray:(NSArray<UIImage*>*)imageArray;




@end

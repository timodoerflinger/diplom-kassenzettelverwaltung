//
//  OpenCVWrapper.m
//  OpenCImageStitching2
//
//  Created by Timo on 22.04.18.
//  Copyright © 2018 Timo. All rights reserved.
//

#import "OpenCVWrapper.h"

//#import <opencv2/opencv.hpp>
#include "opencv2/stitching.hpp"
#include "opencv2/highgui.hpp"
#include "opencv2/imgcodecs.hpp"

#import <opencv2/calib3d.hpp>
#import <opencv2/features2d.hpp>
#import <opencv2/imgproc/imgproc.hpp>


#import "opencv2/imgcodecs/ios.h"
#import "opencv2/stitching.hpp"

#import "stitching.h"
#import "UIImage+OpenCV.h"
#import "UIImage+Rotate.h"

@interface OpenCVWrapper ()

@end

@implementation OpenCVWrapper

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


+(UIImage *) makeGrayFromImage:(UIImage *) image{
    
    //Create a variable from type cv::Mat
    cv::Mat imageMat;
    //Convert an UIImage to a cv::Mat
    UIImageToMat(image, imageMat);
    //Create new variable from type cv::Mat
    cv::Mat grayMat;
    //Convert the color from source imageMat to target grayMat
    cv::cvtColor(imageMat, grayMat, CV_BGR2GRAY);
    
    //Return the converted image as
    return MatToUIImage(grayMat);
    
}


//https://docs.opencv.org/3.1.0/df/d0d/tutorial_find_contours.html
//https://docs.opencv.org/3.1.0/d4/d73/tutorial_py_contours_begin.html
//works, but not usable
+(UIImage *) processPerspectiveTransformation:(UIImage *) image{
    
    cv::Mat imageMat;
    cv::Mat imageMat2;
    UIImageToMat(image, imageMat);
    
    //Prepare the image for findContours
    cv::cvtColor(imageMat, imageMat, CV_BGR2GRAY);
    cv::threshold(imageMat, imageMat, 128, 255, CV_THRESH_BINARY);
    
    //Find the contours. Use the contourOutput Mat so the original image doesn't get overwritten
    std::vector<std::vector<cv::Point> > contours;
    cv::Mat contourOutput = imageMat.clone();
    //cv::findContours( contourOutput, contours, CV_RETR_LIST, CV_CHAIN_APPROX_NONE );
    cv::findContours( contourOutput, contours, cv::RETR_CCOMP, cv::CHAIN_APPROX_SIMPLE );
    
    
    //Draw the contours
    cv::Mat contourImage(imageMat.size(), CV_8UC3, cv::Scalar(0,0,0));
    cv::Scalar colors[3];
    colors[0] = cv::Scalar(255, 0, 0);
    colors[1] = cv::Scalar(0, 255, 0);
    colors[2] = cv::Scalar(0, 0, 255);
    for (int idx = 0; idx < contours.size(); idx++) {
        cv::drawContours(contourImage, contours, idx, colors[idx % 3]);
    }


    return MatToUIImage(contourImage);
    
}


+ (UIImage*) processImageWithOpenCV: (UIImage*) inputImage
{
    NSArray* imageArray = [NSArray arrayWithObject:inputImage];
    UIImage* result = [[self class] processWithArray:imageArray];
    return result;
}

+ (UIImage*) processWithOpenCVImage1:(UIImage*)inputImage1 image2:(UIImage*)inputImage2;
{
    NSArray* imageArray = [NSArray arrayWithObjects:inputImage1,inputImage2,nil];
    UIImage* result = [[self class] processWithArray:imageArray];
    return result;
}

+ (UIImage*) processWithArray:(NSArray*)imageArray
{
    if ([imageArray count]==0){
        NSLog (@"imageArray is empty");
        return 0;
    }
    std::vector<cv::Mat> matImages;
    
    for (id image in imageArray) {
        if ([image isKindOfClass: [UIImage class]]) {
            /*
             All images taken with the iPhone/iPa cameras are LANDSCAPE LEFT orientation. The  UIImage imageOrientation flag is an instruction to the OS to transform the image during display only. When we feed images into openCV, they need to be the actual orientation that we expect them to be for stitching. So we rotate the actual pixel matrix here if required.
             */
            UIImage* rotatedImage = [image rotateToImageOrientation];
            cv::Mat matImage = [rotatedImage CVMat3];
            NSLog (@"matImage: %@",image);
            matImages.push_back(matImage);
        }
    }
    NSLog (@"stitching...");
    cv::Mat stitchedMat = stitch (matImages);
    UIImage* result =  [UIImage imageWithCVMat:stitchedMat];
    return result;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

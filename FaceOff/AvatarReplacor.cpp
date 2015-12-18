//
//  AvatarReplacor.cpp
//  CoreAlgorithmTest
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#include "AvatarReplacor.h"
#include "AvatarDetector.hpp"


AvatarReplacor::AvatarReplacor() : leftRegion(0, 0, 0, 0), rightRegion(0, 0, 0, 0) {
    isInitialized = false;
    isDetectionFinished = false;
    std::cout << "Constructor called" << endl;
}

AvatarReplacor::~AvatarReplacor() {
    std::cout << "Deconstructor called" << endl;
}

void AvatarReplacor::setAvatarMinSize(int minWidth, int minHeight) {
    avatarMinSize = cv::Size(minWidth, minHeight);
}

void AvatarReplacor::setAvatarMaxSize(int maxWidth, int maxHeight) {
    avatarMaxSize = cv::Size(maxWidth, maxHeight);
}

void AvatarReplacor::setLeftRegion(cv::Rect rect) {
    leftRegion = rect;
}

void AvatarReplacor::setRightRegion(cv::Rect rect) {
    rightRegion = rect;
}

void AvatarReplacor::setTopRegion(cv::Rect rect) {
    topRegion = rect;
}

void AvatarReplacor::setBackgroundColorThresh(int thresh) {
    backgroundColorThresh = thresh;
}

std::vector<cv::Rect> detectAvatars(Mat & image, cv::Rect rect, int thresh) {
    Mat roi = image(rect).clone();
    if (roi.channels() == 4) {
        cvtColor(roi, roi, CV_BGRA2GRAY);
    }
    return AvatarDetector::findAvatars(roi, thresh);
}

void AvatarReplacor::setImage(cv::Mat & im) {
    image = im.clone();
    resultImage = im.clone();
    
    if (!isInitialized) {
        throw Exception();
    } else {
        leftRects = detectAvatars(image, leftRegion, backgroundColorThresh);
        rightRects = detectAvatars(image, rightRegion, backgroundColorThresh);
        isDetectionFinished = true;
    }
}

void AvatarReplacor::replaceAvatar(const cv::Mat &avatar, SIDE side) {
    
    Mat roi;
    
    vector<cv::Rect> rects;
    cv::Rect rect;
    if (side == SIDE_LEFT) {
        rects = leftRects;
        rect = leftRegion;
    } else {
        rects = rightRects;
        rect = rightRegion;
    }
    
    for (int i = 0; i < rects.size(); i++) {
        
        cout << rects[i].tl().x << " " << rects[i].tl().y << " " << rects[i].width << " " << rects[i].height << endl;
        
        if (rects[i].height <= avatarMaxSize.height && rects[i].height >= avatarMinSize.height
            && rects[i].width >= avatarMinSize.width && rects[i].width <= avatarMaxSize.width) {

            Mat temp;
            
            resize(avatar, temp, avatarMaxSize);
            
            if (rects[i].tl().y < 10) {
                temp = temp(cv::Rect(0, avatarMaxSize.height - rects[i].height, avatarMaxSize.width, rects[i].height));
            } else {
                temp = temp(cv::Rect(0, 0, avatarMaxSize.width, rects[i].height));
            }
            
            cv::Rect tempRect(cv::Point(rects[i].tl().x + rect.tl().x, rects[i].tl().y + rect.tl().y),
                              cv::Size(avatarMaxSize.width, rects[i].height));
            temp.copyTo(resultImage(tempRect));
        }
    }
    
    //return resultImage;
}

void AvatarReplacor::finishInitialization() {
    isInitialized = true;
}

void AvatarReplacor::setFontSize(int size) {
    fontSize = size;
}

void AvatarReplacor::replaceTitle(bool replace) {
    //Mat roi = Mat::zeros(topRegion.height, topRegion.width, CV_8UC4);
    if (replace) {
        Mat roi(topRegion.size(), CV_8UC4, cv::Scalar(50, 50, 50, 1));
        cout << image.channels() << image.type() << endl;
        cout << roi.channels()  << roi.type() << endl;
        cout << roi.size().width << " " << roi.size().height << endl;
        cout << resultImage(topRegion).size().width << " " << resultImage(topRegion).size().height << endl;
        
        roi.copyTo(resultImage(topRegion));
        
        putText(resultImage, "@FaceOff", cv::Point(topRegion.tl().x + topRegion.size().width * 0.3, topRegion.tl().y + topRegion.size().height * 0.6), FONT_HERSHEY_SCRIPT_SIMPLEX, fontSize, cv::Scalar(255, 255, 255), 2);
    }
    else {
        image(topRegion).copyTo(resultImage(topRegion));
    }
    
    
    //return resultImage;
}

bool AvatarReplacor::isModified(const cv::Mat im) {
    cv::Mat diff = image != im;
    cvtColor(diff, diff, CV_BGRA2GRAY);
    bool eq = (cv::countNonZero(diff) != 0);
    
    return eq;
}

Mat AvatarReplacor::getResultImage() {
    return resultImage;
}
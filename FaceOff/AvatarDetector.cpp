//
//  AvatarDector.cpp
//  CoreAlgorithmTest
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#include "AvatarDetector.hpp"

vector<Rect> AvatarDetector::findAvatarsNaive(const cv::Mat & image, int thresh, int maxDiff)
{
    std::cout << "Image Channels : " << image.channels() << std::endl;
    Mat temp;
    if(image.channels() == 4)
    {
        cvtColor(image, temp, CV_BGRA2GRAY);
    }
    else{
        temp = image.clone();
    }
    vector<Rect> boundRect;
    
    bool inAvatar = false;
    int upper = 0;
    int bottom = 1;
    
    for(int i = 0; i < image.rows; i++)
    {
        
        bool isWholeLineEqualsToThresh = true;
        for(int j = 0; j < image.cols; j++)
        {
            if(abs((int)image.at<unsigned char>(i, j) - thresh) > maxDiff)
            {
                isWholeLineEqualsToThresh = false;
                if(!inAvatar)
                {
                    inAvatar = true;
                    upper = i;
                    break;
                }
            }
        }
        
        if(isWholeLineEqualsToThresh)
        {
            if(inAvatar)
            {
                bottom = i;
                inAvatar = false;
                
                Rect rect(0, upper, image.cols, bottom - upper);
                boundRect.push_back(rect);
            }
        }
    }
    
    if(inAvatar)
    {
        Rect rect(0, upper, image.cols, image.rows - upper);
        boundRect.push_back(rect);
    }
    
    return boundRect;
}

vector<Rect> AvatarDetector::findAvatarsBoundRect(const cv::Mat & image, int thresh)
{
    Mat gray = image.clone();
    
    if (gray.channels() == 4) {
        cvtColor(gray, gray, CV_BGRA2GRAY);
    }
    
    Mat thresholdOutput;
    vector<vector<Point> > contours;
    vector<Vec4i> hierarchy;
    
    threshold( gray, thresholdOutput, thresh, 255, THRESH_BINARY_INV);
    findContours( thresholdOutput, contours, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, Point(0, 0));
    
    vector<vector<Point> > contours_poly(contours.size());
    vector<Rect> boundRect(contours.size());
    
    for(int i = 0; i < contours.size(); i++)
    {
        approxPolyDP( cv::Mat(contours[i]), contours_poly[i], 3, true);
        boundRect[i] = boundingRect( cv::Mat(contours_poly[i]));
    }
    
    return boundRect;
    
}

vector<Rect> AvatarDetector::findAvatars(const cv::Mat & image, int thresh)
{
    //return findAvatarsBoundRect(image, thresh);
    return findAvatarsNaive(image, thresh, 9);
}
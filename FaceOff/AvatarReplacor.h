//
//  AvatarReplacor.hpp
//  CoreAlgorithmTest
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#ifndef AvatarReplacor_hpp
#define AvatarReplacor_hpp

#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;

enum SIDE {
    SIDE_LEFT = 1 << 0,
    SIDE_RIGHT = 1 << 1,
    SIDE_TOP = 1 << 2
};

class AvatarReplacor {
public:
    AvatarReplacor();
    ~AvatarReplacor();
    
    void setLeftRegion(cv::Rect rect);
    void setRightRegion(cv::Rect rect);
    void setTopRegion(cv::Rect rect);
    void setAvatarMinSize(int minWidth, int minHeight);
    void setAvatarMaxSize(int maxWidth, int maxHeight);
    void setBackgroundColorThresh(int thresh);
    void setImage(cv::Mat & image);
    void setFontSize(int size);
    void finishInitialization();
    
    void replaceAvatar(const Mat & avatar, SIDE side);
    //static Mat replaceAvatar(Mat & image, const std::vector<cv::Rect> rects, const Mat & avatar, int minWidth, int maxHeight);
    void replaceTitle(bool replace);
    
    Mat getResultImage();
    
    
    bool isModified(const cv::Mat);
    
private:
    Mat image;
    Mat resultImage;
    std::vector<cv::Rect> leftRects;
    std::vector<cv::Rect> rightRects;
    cv::Rect leftRegion;
    cv::Rect rightRegion;
    cv::Rect topRegion;
    int backgroundColorThresh;
    cv::Size avatarMinSize;
    cv::Size avatarMaxSize;
    bool isDetectionFinished;
    bool isInitialized;
    int fontSize;
};

#endif /* AvatarReplacor_hpp */

//
//  AvatarDector.hpp
//  CoreAlgorithmTest
//
//  Created by ZRY on 15/11/5.
//  Copyright © 2015年 Malus. All rights reserved.
//

#ifndef AvatarDetector_hpp
#define AvatarDetector_hpp

#include <opencv2/opencv.hpp>
#include <vector>

using namespace std;
using namespace cv;

class AvatarDetector
{
public:
    static std::vector<cv::Rect> findAvatars(const Mat &, int thresh);
    static std::vector<cv::Rect> findAvatarsNaive(const Mat &, int thresh, int maxDiff);
    static std::vector<cv::Rect> findAvatarsBoundRect(const Mat &, int thresh);
};

#endif /* AvatarDector_hpp */

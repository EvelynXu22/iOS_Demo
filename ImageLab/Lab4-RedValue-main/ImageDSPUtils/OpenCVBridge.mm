//
//  OpenCVBridge.m
//  LookinLive
//
//  Created by Eric Larson.
//  Copyright (c) Eric Larson. All rights reserved.
//

#import "OpenCVBridge.hh"
#import "FFTHelper.h"

using namespace cv;

@interface OpenCVBridge()
@property (nonatomic) cv::Mat image;
@property (strong,nonatomic) CIImage* frameInput;
@property (nonatomic) CGRect bounds;
@property (nonatomic) CGAffineTransform transform;
@property (nonatomic) CGAffineTransform inverseTransform;
@property (atomic) cv::CascadeClassifier classifier;
@property (atomic) cv::CascadeClassifier faceCascade;
@property (atomic) cv::CascadeClassifier eyesCascade;
//@property FFTHelper fftHelper;

@end

@implementation OpenCVBridge


int i = 0;

// red value buffer
vector<float> redValue;

// text which needs to be printed on image
char text[50];

#pragma mark ===Write Your Code Here===
// alternatively you can subclass this class and override the process image function
-()printText:(int)pText{
//    std::string *string = new std::string([pText UTF8String]);
    sprintf(text, "%d",pText);
    cv::putText(_image, text, cv::Point(80, 200), FONT_HERSHEY_PLAIN, 0.75, Scalar::all(255), 1, 2);
    
    
    return 0;
}

-(float)processFinger{

    cv::Mat image_copy;
    
    Scalar avgPixelIntensity;
    

    cvtColor(_image, image_copy, CV_BGRA2BGR); // get rid of alpha for processing
    avgPixelIntensity = cv::mean( image_copy );

    float green = avgPixelIntensity.val[1];
    float blue = avgPixelIntensity.val[2];
    float red = avgPixelIntensity.val[0];
 
    // show RBG value
    sprintf(text,"Avg. R: %.0f, G: %.0f, B: %.0f", red,green,blue);
    cv::putText(_image, text, cv::Point(80, 100), FONT_HERSHEY_PLAIN, 0.75, Scalar::all(255), 1, 2);

    // if haven't store 100 points
    if(i<100){
        // if been covered
        if(red <= 250 && green <= 80 && blue <= 80){
            //store one point
            i++;
            redValue.push_back(red);

        }

    }
    // if already stored 100 points
    else{
        // if still been covered
        if(red <= 250 && green <= 80 && blue <= 80){
            sprintf(text, "Camera has been covered!!");
            cv::putText(_image, text, cv::Point(80, 300), FONT_HERSHEY_PLAIN, 0.75, Scalar::all(255), 1, 2);
            

            float output = redValue.front();
            const auto it = redValue.begin();
            
            // pop front
            redValue.erase(it);
            // push back
            redValue.push_back(red);
            
            // print Red value to image
            sprintf(text,"Red Value. R: %.1f", output);
            cv::putText(_image, text, cv::Point(80, 400), FONT_HERSHEY_PLAIN, 0.75, Scalar::all(255), 1, 2);
            
//            for (int i=0; i<100; i++) {
//                std::cout<<redValue[i]<<" ";
//            }
            return output;

        }else{
            // Removed finger. Reset index and restart store point
            i = 0;
            return -1;
        }
        
    }
    return  -1;
}

#pragma mark Define Custom Functions Here
-(void)processImage{
    
    cv::Mat frame_gray,image_copy;
    const int kCannyLowThreshold = 300;
    const int kFilterKernelSize = 5;
    int i = 0;
    
    Scalar avgPixelIntensity;
    
    switch (self.processType) {
        case 0:
        {
            avgPixelIntensity = cv::mean( image_copy );
            float red = avgPixelIntensity.val[0];
            float green = avgPixelIntensity.val[1];
            float blue = avgPixelIntensity.val[2];
//            sprintf(text,"Avg. R: %.0f, G: %.0f, B: %.0f", red,green,blue);
            int threshold = 30;
            float redValue[100];
            float greenValue[100];
            float blueValue[100];

            
//            cv::putText(_image, text, cv::Point(80, 100), FONT_HERSHEY_PLAIN, 0.75, Scalar::all(255), 1, 2);

            // if haven't store 100 points
            if(i<100){
                // if been covered
                if(red <= threshold || green <= threshold || blue <= threshold){
                    //store one point
                    i++;
                    redValue[i] = red;
                    greenValue[i] = green;
                    blueValue[i] = blue;
                    std::cout<<"red:"<<red<<" green:"<<green<<" blue:"<<blue;

                }

            }
            // if already stored 100 points
            else{
                // if still been covered
                if(red <= threshold || green <= threshold || blue <= threshold){
//                    sprintf(text, "Camera has been covered!!");
//                    cv::putText(_image, text, cv::Point(80, 300), FONT_HERSHEY_PLAIN, 0.75, Scalar::all(255), 1, 2);
                    printf("true");
//                    std::cout<<redValue[0];
//                    return true;
                // if uncovered
                }else{
                    // reset index and restart store point
                    i = 0;
                }
                
            }
            printf("false");
//            return false;

        }
        case 1:
        {
            
//            int i = 0;
//            cvtColor(_image, image_copy, CV_BGRA2GRAY);
//            vector<cv::Rect> faces,eyes;
//
//            self.faceCascade.detectMultiScale(image_copy, faces);
//            for (vector<cv::Rect>::const_iterator r = faces.begin(); r != faces.end(); r++, i++)
//            {
//                cv::rectangle(_image, *r, Scalar(0,255,0), 1, 1, 0);//在img上绘制出检测到的面部矩形框，绿色框
////                Mat faceROI = image_copy(*r);//设置图片感兴趣区域，也就是改变了图片原点和长宽，实际像素数据没有丢失
//                self.eyesCascade.detectMultiScale(image_copy, eyes);
//                for (vector<cv::Rect>::const_iterator e = eyes.begin(); e != eyes.end(); e++)
//                {
//                    cv::Rect eyeR;
//                    eyeR.x = r->x + e->x;//从感兴趣区域映射到整个图片区域
//                    eyeR.y = r->y + e->y;
//                    eyeR.height = e->height;
//                    eyeR.width = e->width;
//                    cv::rectangle(_image, eyeR, Scalar(0, 255, 255), 1, 1, 0);//绘制检测到的眼睛矩形框，黄色框
//                }
//                break;
//            }
        }
        case 2:
        {
            static uint counter = 0;
            cvtColor(_image, image_copy, CV_BGRA2BGR);
            for(int i=0;i<counter;i++){
                for(int j=0;j<counter;j++){
                    uchar *pt = image_copy.ptr(i, j);
                    pt[0] = 255;
                    pt[1] = 0;
                    pt[2] = 255;
                    
                    pt[3] = 255;
                    pt[4] = 0;
                    pt[5] = 0;
                }
            }
            cvtColor(image_copy, _image, CV_BGR2BGRA);
            
            counter++;
            counter = counter>50 ? 0 : counter;
            break;
        }
        case 3:
        { // fine, adding scoping to case statements to get rid of jump errors
            char text[50];
            Scalar avgPixelIntensity;
            
            cvtColor(_image, image_copy, CV_BGRA2BGR); // get rid of alpha for processing
            avgPixelIntensity = cv::mean( image_copy );
            sprintf(text,"Avg. B: %.0f, G: %.0f, R: %.0f", avgPixelIntensity.val[0],avgPixelIntensity.val[1],avgPixelIntensity.val[2]);
            cv::putText(_image, text, cv::Point(0, 10), FONT_HERSHEY_PLAIN, 0.75, Scalar::all(255), 1, 2);
            break;
        }
        case 4:
        {
            vector<Mat> layers;
            cvtColor(_image, image_copy, CV_BGRA2BGR);
            cvtColor(image_copy, image_copy, CV_BGR2HSV);
            
            //grab  just the Hue chanel
            cv::split(image_copy,layers);
            
            // shift the colors
            cv::add(layers[0],80.0,layers[0]);
            
            // get back image from separated layers
            cv::merge(layers,image_copy);
            
            cvtColor(image_copy, image_copy, CV_HSV2BGR);
            cvtColor(image_copy, _image, CV_BGR2BGRA);
            break;
        }
        case 5:
        {
            //============================================
            //threshold the image using the utsu method (optimal histogram point)
            cvtColor(_image, image_copy, COLOR_BGRA2GRAY);
            cv::threshold(image_copy, image_copy, 0, 255, CV_THRESH_BINARY | CV_THRESH_OTSU);
            cvtColor(image_copy, _image, CV_GRAY2BGRA); //add back for display
            break;
        }
        case 6:
        {
            //============================================
            //do some blurring (filtering)
            cvtColor(_image, image_copy, CV_BGRA2BGR);
            Mat gauss = cv::getGaussianKernel(23, 17);
            cv::filter2D(image_copy, image_copy, -1, gauss);
            cvtColor(image_copy, _image, CV_BGR2BGRA);
            break;
        }
        case 7:
        {
            //============================================
            // canny edge detector
            // Convert captured frame to grayscale
            cvtColor(_image, image_copy, COLOR_BGRA2GRAY);
            
            // Perform Canny edge detection
            Canny(image_copy, _image,
                  kCannyLowThreshold,
                  kCannyLowThreshold*7,
                  kFilterKernelSize);
            
            // copy back for further processing
            cvtColor(_image, _image, CV_GRAY2BGRA); //add back for display
            break;
        }
        case 8:
        {
            //============================================
            // contour detector with rectangle bounding
            // Convert captured frame to grayscale
            vector<vector<cv::Point> > contours; // for saving the contours
            vector<cv::Vec4i> hierarchy;
            
            cvtColor(_image, frame_gray, CV_BGRA2GRAY);
            
            // Perform Canny edge detection
            Canny(frame_gray, image_copy,
                  kCannyLowThreshold,
                  kCannyLowThreshold*7,
                  kFilterKernelSize);
            
            // convert edges into connected components
            findContours( image_copy, contours, hierarchy, CV_RETR_CCOMP, CV_CHAIN_APPROX_SIMPLE, cv::Point(0, 0) );
            
            // draw boxes around contours in the original image
            for( int i = 0; i< contours.size(); i++ )
            {
                cv::Rect boundingRect = cv::boundingRect(contours[i]);
                cv::rectangle(_image, boundingRect, Scalar(255,255,255,255));
            }
            break;
            
        }
        case 9:
        {
            //============================================
            // contour detector with full bounds drawing
            // Convert captured frame to grayscale
            vector<vector<cv::Point> > contours; // for saving the contours
            vector<cv::Vec4i> hierarchy;
            
            cvtColor(_image, frame_gray, CV_BGRA2GRAY);
            
            
            // Perform Canny edge detection
            Canny(frame_gray, image_copy,
                  kCannyLowThreshold,
                  kCannyLowThreshold*7,
                  kFilterKernelSize);
            
            // convert edges into connected components
            findContours( image_copy, contours, hierarchy,
                         CV_RETR_CCOMP,
                         CV_CHAIN_APPROX_SIMPLE,
                         cv::Point(0, 0) );
            
            // draw the contours to the original image
            for( int i = 0; i< contours.size(); i++ )
            {
                Scalar color = Scalar( rand()%255, rand()%255, rand()%255, 255 );
                drawContours( _image, contours, i, color, 1, 4, hierarchy, 0, cv::Point() );
                
            }
            break;
        }
        case 10:
        {
            /// Convert it to gray
            cvtColor( _image, image_copy, CV_BGRA2GRAY );
            
            /// Reduce the noise
            GaussianBlur( image_copy, image_copy, cv::Size(3, 3), 2, 2 );
            
            vector<Vec3f> circles;
            
            /// Apply the Hough Transform to find the circles
            HoughCircles( image_copy, circles,
                         CV_HOUGH_GRADIENT,
                         1, // downsample factor
                         image_copy.rows/20, // distance between centers
                         kCannyLowThreshold/2, // canny upper thresh
                         40, // magnitude thresh for hough param space
                         0, 0 ); // min/max centers
            
            /// Draw the circles detected
            for( size_t i = 0; i < circles.size(); i++ )
            {
                cv::Point center(cvRound(circles[i][0]), cvRound(circles[i][1]));
                int radius = cvRound(circles[i][2]);
                // circle center
                circle( _image, center, 3, Scalar(0,255,0,255), -1, 8, 0 );
                // circle outline
                circle( _image, center, radius, Scalar(0,0,255,255), 3, 8, 0 );
            }
            break;
        }
        case 11:
        {
            // example for running Haar cascades
            //============================================
            // generic Haar Cascade
            
            cvtColor(_image, image_copy, CV_BGRA2GRAY);
            vector<cv::Rect> objects;
            
            // run classifier
            // error if this is not set!
            self.classifier.detectMultiScale(image_copy, objects);
            
            // display bounding rectangles around the detected objects
            for( vector<cv::Rect>::const_iterator r = objects.begin(); r != objects.end(); r++)
            {
                cv::rectangle( _image, cvPoint( r->x, r->y ), cvPoint( r->x + r->width, r->y + r->height ), Scalar(0,0,255,255));
            }
            //image already in the correct color space
            break;
        }
            
        default:
            break;
    
    }
}


#pragma mark ====Do Not Manipulate Code below this line!====
-(void)setTransforms:(CGAffineTransform)trans{
    self.inverseTransform = trans;
    self.transform = CGAffineTransformInvert(trans);
}

-(void)loadHaarCascadeWithFilename:(NSString*)filename{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"xml"];
    self.classifier = cv::CascadeClassifier([filePath UTF8String]);
}

-(instancetype)init{
    self = [super init];
    
    if(self != nil){
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.transform = CGAffineTransformScale(self.transform, -1.0, 1.0);
        
        self.inverseTransform = CGAffineTransformMakeScale(-1.0,1.0);
        self.inverseTransform = CGAffineTransformRotate(self.inverseTransform, -M_PI_2);
        
        
    }
    return self;
}

#pragma mark Bridging OpenCV/CI Functions
// code manipulated from
// http://stackoverflow.com/questions/30867351/best-way-to-create-a-mat-from-a-ciimage
// http://stackoverflow.com/questions/10254141/how-to-convert-from-cvmat-to-uiimage-in-objective-c


-(void) setImage:(CIImage*)ciFrameImage
      withBounds:(CGRect)faceRectIn
      andContext:(CIContext*)context{
    
    CGRect faceRect = CGRect(faceRectIn);
    faceRect = CGRectApplyAffineTransform(faceRect, self.transform);
    ciFrameImage = [ciFrameImage imageByApplyingTransform:self.transform];
    
    
    //get face bounds and copy over smaller face image as CIImage
    //CGRect faceRect = faceFeature.bounds;
    _frameInput = ciFrameImage; // save this for later
    _bounds = faceRect;
    CIImage *faceImage = [ciFrameImage imageByCroppingToRect:faceRect];
    CGImageRef faceImageCG = [context createCGImage:faceImage fromRect:faceRect];
    
    // setup the OPenCV mat fro copying into
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(faceImageCG);
    CGFloat cols = faceRect.size.width;
    CGFloat rows = faceRect.size.height;
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    _image = cvMat;
    
    // setup the copy buffer (to copy from the GPU)
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                // Pointer to backing data
                                                    cols,                      // Width of bitmap
                                                    rows,                      // Height of bitmap
                                                    8,                         // Bits per component
                                                    cvMat.step[0],             // Bytes per row
                                                    colorSpace,                // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    // do the copy
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), faceImageCG);
    
    // release intermediary buffer objects
    CGContextRelease(contextRef);
    CGImageRelease(faceImageCG);
    
}

-(CIImage*)getImage{
    
    // convert back
    // setup NS byte buffer using the data from the cvMat to show
    NSData *data = [NSData dataWithBytes:_image.data
                                  length:_image.elemSize() * _image.total()];
    
    CGColorSpaceRef colorSpace;
    if (_image.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    // setup buffering object
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // setup the copy to go from CPU to GPU
    CGImageRef imageRef = CGImageCreate(_image.cols,                                     // Width
                                        _image.rows,                                     // Height
                                        8,                                              // Bits per component
                                        8 * _image.elemSize(),                           // Bits per pixel
                                        _image.step[0],                                  // Bytes per row
                                        colorSpace,                                     // Colorspace
                                        kCGImageAlphaNone | kCGBitmapByteOrderDefault,  // Bitmap info flags
                                        provider,                                       // CGDataProviderRef
                                        NULL,                                           // Decode
                                        false,                                          // Should interpolate
                                        kCGRenderingIntentDefault);                     // Intent
    
    // do the copy inside of the object instantiation for retImage
    CIImage* retImage = [[CIImage alloc]initWithCGImage:imageRef];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(self.bounds.origin.x, self.bounds.origin.y);
    retImage = [retImage imageByApplyingTransform:transform];
    retImage = [retImage imageByApplyingTransform:self.inverseTransform];
    
    // clean up
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return retImage;
}

-(CIImage*)getImageComposite{
    
    // convert back
    // setup NS byte buffer using the data from the cvMat to show
    NSData *data = [NSData dataWithBytes:_image.data
                                  length:_image.elemSize() * _image.total()];
    
    CGColorSpaceRef colorSpace;
    if (_image.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    // setup buffering object
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // setup the copy to go from CPU to GPU
    CGImageRef imageRef = CGImageCreate(_image.cols,                                     // Width
                                        _image.rows,                                     // Height
                                        8,                                              // Bits per component
                                        8 * _image.elemSize(),                           // Bits per pixel
                                        _image.step[0],                                  // Bytes per row
                                        colorSpace,                                     // Colorspace
                                        kCGImageAlphaNone | kCGBitmapByteOrderDefault,  // Bitmap info flags
                                        provider,                                       // CGDataProviderRef
                                        NULL,                                           // Decode
                                        false,                                          // Should interpolate
                                        kCGRenderingIntentDefault);                     // Intent
    
    // do the copy inside of the object instantiation for retImage
    CIImage* retImage = [[CIImage alloc]initWithCGImage:imageRef];
    // now apply transforms to get what the original image would be inside the Core Image frame
    CGAffineTransform transform = CGAffineTransformMakeTranslation(self.bounds.origin.x, self.bounds.origin.y);
    retImage = [retImage imageByApplyingTransform:transform];
    CIFilter* filt = [CIFilter filterWithName:@"CISourceAtopCompositing"
                          withInputParameters:@{@"inputImage":retImage,@"inputBackgroundImage":self.frameInput}];
    retImage = filt.outputImage;
    
    // clean up
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    retImage = [retImage imageByApplyingTransform:self.inverseTransform];
    
    return retImage;
}




@end

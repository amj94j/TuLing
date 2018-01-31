//
//  CameraViewController.h
//  LLSimpleCamera
//
//  Created by Ömer Faruk Gül on 24/10/14.
//  Copyright (c) 2014 Ömer Farul Gül. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef enum : NSUInteger {
    //后置摄像头
    LLCameraPositionRear,
    //前置摄像头
    LLCameraPositionFront
} LLCameraPosition;

typedef enum : NSUInteger {
    
    //相机闪光灯模式，默认关闭
    LLCameraFlashOff,
    LLCameraFlashOn,
    LLCameraFlashAuto
} LLCameraFlash;

typedef enum : NSUInteger {
   
    //相机滤镜效果,默认关闭
    LLCameraMirrorOff,
    LLCameraMirrorOn,
    LLCameraMirrorAuto
} LLCameraMirror;

extern NSString *const LLSimpleCameraErrorDomain;
typedef enum : NSUInteger {
    //相机许可
    LLSimpleCameraErrorCodeCameraPermission = 10,
    //电话权限许可
    LLSimpleCameraErrorCodeMicrophonePermission = 11,
    //通话许可
    LLSimpleCameraErrorCodeSession = 12,
    LLSimpleCameraErrorCodeVideoNotEnabled = 13
} LLSimpleCameraErrorCode; //权限许可

@interface LLSimpleCamera : UIViewController

/**
 * 更改设备触发
 */
@property (nonatomic, copy) void (^onDeviceChange)(LLSimpleCamera *camera, AVCaptureDevice *device);

/**
 *
 在任何类型的错误触发.
 */
@property (nonatomic, copy) void (^onError)(LLSimpleCamera *camera, NSError *error);

/**
 *
 相机开始录制时触发
 */
@property (nonatomic, copy) void (^onStartRecording)(LLSimpleCamera* camera);

/**
 * 相机的质量，建立一个以avcapturesessionpreset常数。
 * 请务必在调用前调用初始化方法，否则会出错。
 */
@property (copy, nonatomic) NSString *cameraQuality;

/**
 *
 相机闪光灯模式.
 */
@property (nonatomic, readonly) LLCameraFlash flash;

/**
 * Camera mirror mode.
 */
@property (nonatomic) LLCameraMirror mirror;

/**
 *
 相机前后镜头模式 .
 */
@property (nonatomic) LLCameraPosition position;

/**
  白平衡模式。默认值是
 * White balance mode. Default is: AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance
 */
@property (nonatomic) AVCaptureWhiteBalanceMode whiteBalanceMode;

/**
 *
 布尔值，以显示是否启用视频 .
 */
@property (nonatomic, getter=isVideoEnabled) BOOL videoEnabled;

/**
 * 表示当前摄像机是否在当前时刻录制视频的布尔值。
 */
@property (nonatomic, getter=isRecording) BOOL recording;

/**
 * 布尔值表示如果变焦is enabled to.
 */
@property (nonatomic, getter=isZoomingEnabled) BOOL zoomingEnabled;

/**
 * 浮动值设置最大比例因子
 */
@property (nonatomic, assign) CGFloat maxScale;

/**
 
 
 fixess定位后的图像被设置为“是”
 * Fixess the orientation after the image is captured is set to Yes.
 * see: http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
 */
@property (nonatomic) BOOL fixOrientationAfterCapture;

/**
 *
 
 如果你不想让用户触发聚焦。默认启用。
 */
@property (nonatomic) BOOL tapToFocus;

/**
 * 是的如果你设置你的视图控制器不允许自转,
 *
 
 不过，你想采取设备旋转考虑到无论什么。默认情况下禁用 .
 */
@property (nonatomic) BOOL useDeviceOrientation;

/**
 * 使用此方法前llsimplecamera请求初始化摄像头权限.
 */
+ (void)requestCameraPermission:(void (^)(BOOL granted))completionBlock;

/**
 * 使用此方法在初始化请求许可llsimplecamera麦克风.
 */
+ (void)requestMicrophonePermission:(void (^)(BOOL granted))completionBlock;

/**
 *
 Returns an instance of LLSimpleCamera with the given quality
 
 返回与给定质量的llsimplecamera实例 .
 *
 
 质量参数可以是任何变量从avcapturesessionpreset .
 */
- (instancetype)initWithQuality:(NSString *)quality position:(LLCameraPosition)position videoEnabled:(BOOL)videoEnabled;

/**
 * 返回llsimplecamera质量实例"AVCaptureSessionPresetHigh" and position "CameraPositionBack".
 * @param
 
 
 //videenabled：设置为“是”使视频记录 .
 */
- (instancetype)initWithVideoEnabled:(BOOL)videoEnabled;

/**
 * 开始运行摄像机会话.
 */
- (void)start;

/**
 * 停止正在运行的摄像机会话。当应用程序不显示视图时，需要调用.
 */
- (void)stop;


/**
 * Capture an image.
 * @param onCapture a block triggered after the capturing the photo.
 * @param exactSeenImage If set YES, then the image is cropped to the exact size as the preview. So you get exactly what you see.
 * @param animationBlock you can create your own animation by playing with preview layer.
 */
-(void)capture:(void (^)(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error))onCapture exactSeenImage:(BOOL)exactSeenImage animationBlock:(void (^)(AVCaptureVideoPreviewLayer *))animationBlock;

/**
 * Capture an image.
 * @param onCapture a block triggered after the capturing the photo.
 * @param exactSeenImage If set YES, then the image is cropped to the exact size as the preview. So you get exactly what you see.
 */
-(void)capture:(void (^)(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error))onCapture exactSeenImage:(BOOL)exactSeenImage;

/**
 * Capture an image.
 * @param onCapture a block triggered after the capturing the photo.
 */
-(void)capture:(void (^)(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error))onCapture;

/*
 * Start recording a video with a completion block. Video is saved to the given url.
 */
- (void)startRecordingWithOutputUrl:(NSURL *)url didRecord:(void (^)(LLSimpleCamera *camera, NSURL *outputFileUrl, NSError *error))completionBlock;

/**
 * Stop recording video.
 */
- (void)stopRecording;

/**
 * Attaches the LLSimpleCamera to another view controller with a frame. It basically adds the LLSimpleCamera as a
 * child vc to the given vc.
 * @param vc A view controller.
 * @param frame The frame of the camera.
 */
- (void)attachToViewController:(UIViewController *)vc withFrame:(CGRect)frame;

/**
 * 改变相机的位置（或前面或后面）并返回最终的位置.
 */
- (LLCameraPosition)togglePosition;

/**
 *
 更新相机的闪光灯模式。如果成功，返回true。否则为false .
 */
- (BOOL)updateFlashMode:(LLCameraFlash)cameraFlash;

/**
 * 检查闪光灯可用目前的有源器件.
 */
- (BOOL)isFlashAvailable;

/**
 * Checks if torch (flash for video) is avilable for the currently active device.
 */
- (BOOL)isTorchAvailable;

/**
 *
 改变用户点击屏幕时显示的图层和动画 .
 * @param layer Layer to be displayed
 * @param animation to be applied after the layer is shown
 */
- (void)alterFocusBox:(CALayer *)layer animation:(CAAnimation *)animation;

/**
 *
 
 检查是前摄像头可用 .
 */
+ (BOOL)isFrontCameraAvailable;

/**
 *
 
 检查是后摄像头可用 .
 */
+ (BOOL)isRearCameraAvailable;
@end

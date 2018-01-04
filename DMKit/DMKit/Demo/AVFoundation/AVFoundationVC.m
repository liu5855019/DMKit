//
//  AVFundationVC.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/1/3.
//  Copyright © 2018年 呆木出品. All rights reserved.
//


//参照http://www.jianshu.com/p/c71bfda055fa

//AVFoundation: 音视频数据采集需要用AVFoundation框架.
//
//AVCaptureDevice：硬件设备，包括麦克风、摄像头，通过该对象可以设置物理设备的一些属性（例如相机聚焦、白平衡等）
//
//AVCaptureDeviceInput：硬件输入对象，可以根据AVCaptureDevice创建对应的AVCaptureDeviceInput对象，用于管理硬件输入数据。
//AVCaptureOutput：硬件输出对象，用于接收各类输出数据，通常使用对应的子类AVCaptureAudioDataOutput（声音数据输出对象）、AVCaptureVideoDataOutput（视频数据输出对象）
//AVCaptionConnection:当把一个输入和输出添加到AVCaptureSession之后，AVCaptureSession就会在输入、输出设备之间建立连接,而且通过AVCaptureOutput可以获取这个连接对象。
//AVCaptureVideoPreviewLayer:相机拍摄预览图层，能实时查看拍照或视频录制效果，创建该对象需要指定对应的AVCaptureSession对象，因为AVCaptureSession包含视频输入数据，有视频数据才能展示。
//AVCaptureSession:  协调输入与输出之间传输数据


#pragma mark - 捕获音视频步骤
//1.创建AVCaptureSession对象
//2.获取AVCaptureDevicel录像设备（摄像头），录音设备（麦克风），注意不具备输入数据功能,只是用来调节硬件设备的配置。
//3.根据音频/视频硬件设备(AVCaptureDevice)创建音频/视频硬件输入数据对象(AVCaptureDeviceInput)，专门管理数据输入。
//4.创建视频输出数据管理对象（AVCaptureVideoDataOutput），并且设置样品缓存代理(setSampleBufferDelegate)就可以通过它拿到采集到的视频数据
//5.创建音频输出数据管理对象（AVCaptureAudioDataOutput），并且设置样品缓存代理(setSampleBufferDelegate)就可以通过它拿到采集到的音频数据
//6.将数据输入对象AVCaptureDeviceInput、数据输出对象AVCaptureOutput添加到媒体会话管理对象AVCaptureSession中,就会自动让音频输入与输出和视频输入与输出产生连接.
//7.创建视频预览图层AVCaptureVideoPreviewLayer并指定媒体会话，添加图层到显示容器layer中
//8.启动AVCaptureSession，只有开启，才会开始输入到输出数据流传输。

//视频采集额外功能一（切换摄像头）
//切换摄像头步骤
//1.获取当前视频设备输入对象
//2.判断当前视频设备是前置还是后置
//3.确定切换摄像头的方向
//4.根据摄像头方向获取对应的摄像头设备
//5.创建对应的摄像头输入对象
//6.从会话中移除之前的视频输入对象
//7.添加新的视频输入对象到会话中

//视频采集额外功能二（聚焦光标）
//聚焦光标步骤
//1.监听屏幕的点击
//2.获取点击的点位置，转换为摄像头上的点，必须通过视频预览图层（AVCaptureVideoPreviewLayer）转
//3.设置聚焦光标图片的位置，并做动画
//4.设置摄像头设备聚焦模式和曝光模式(注意：这里设置一定要锁定配置lockForConfiguration,否则报错)



#import "AVFoundationVC.h"
#import <AVFoundation/AVFoundation.h>


@interface AVFoundationVC ()
<AVCaptureVideoDataOutputSampleBufferDelegate,
AVCaptureAudioDataOutputSampleBufferDelegate,
AVCaptureMetadataOutputObjectsDelegate>

/** 协调输入与输出之间传输数据 */
@property (nonatomic ,strong) AVCaptureSession *session;

@property (nonatomic ,strong) AVCaptureDeviceInput *currentVideoDeviceInput;

@property (nonatomic ,strong) AVCaptureDeviceInput *audioDeviceInput;

@property (nonatomic ,strong) AVCaptureConnection *audioConnection;

@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *previedLayer;
/** 聚焦视图 */
@property (nonatomic, strong) UIImageView *focusCursorImageView;

@property (nonatomic , strong) CALayer *aLayer;
@property (nonatomic , strong) NSMutableDictionary *faceLayers;

@end

@implementation AVFoundationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCaputureVideo];
    
    [self setupLayer];
    
    [self setupButtons];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

/**
 *  懒加载聚焦视图
 */
- (UIImageView *)focusCursorImageView
{
    if (_focusCursorImageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"focus"]];
        _focusCursorImageView = imageView;
        [self.view addSubview:_focusCursorImageView];
        CALayer *layer = [self makeFaceLayer];
        layer.bounds = CGRectMake(0, 0, 50, 50);
        [imageView.layer addSublayer:layer];
    }
    return _focusCursorImageView;
}

- (void) setupButtons
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:backButton];
    [backButton setTitle:@"back" forState:UIControlStateNormal];
    backButton.frame = CGRectMake(32, 32, 60, 44);
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:changeButton];
    changeButton.frame = CGRectMake(kScreenW - 60 -32, 32, 60, 44);
    [changeButton setTitle:@"切换" forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(clickChangeButton) forControlEvents:UIControlEventTouchUpInside];
}


- (void) setupCaputureVideo
{
    // 1.创建捕获会话,必须要强引用，否则会被释放
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    _session = captureSession;
    
    // 2.获取摄像头设备，默认是后置摄像头
    AVCaptureDevice *videoDevice = [self getVideoDevice:AVCaptureDevicePositionBack];
    
    // 3.获取声音设备
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    // 4.创建对应视频设备输入对象
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    _currentVideoDeviceInput = videoDeviceInput;
    
    // 5.创建对应音频设备输入对象
    AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    _audioDeviceInput = audioDeviceInput;
    
    // 6.添加到会话中
    // 注意“最好要判断是否能添加输入，会话不能添加空的
    // 6.1 添加视频
    if ([captureSession canAddInput:videoDeviceInput]) {
        [captureSession addInput:videoDeviceInput];
    }
    // 6.2 添加音频
    if ([captureSession canAddInput:audioDeviceInput]) {
        [captureSession addInput:audioDeviceInput];
    }
    
    // 7.获取视频数据输出设备
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    // 7.1 设置代理，捕获视频样品数据
    // 注意：队列必须是串行队列，才能获取到数据，而且不能为空
    dispatch_queue_t videoQueue = dispatch_queue_create("Video Capture Queue", DISPATCH_QUEUE_SERIAL);
    [videoOutput setSampleBufferDelegate:self queue:videoQueue];
    if ([captureSession canAddOutput:videoOutput]) {
        [captureSession addOutput:videoOutput];
    }
    
    // 8.获取音频数据输出设备
    AVCaptureAudioDataOutput *audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    // 8.2 设置代理，捕获视频样品数据
    // 注意：队列必须是串行队列，才能获取到数据，而且不能为空
    dispatch_queue_t audioQueue = dispatch_queue_create("Audio Capture Queue", DISPATCH_QUEUE_SERIAL);
    [audioOutput setSampleBufferDelegate:self queue:audioQueue];
    if ([captureSession canAddOutput:audioOutput]) {
        [captureSession addOutput:audioOutput];
    }
    
    AVCaptureMetadataOutput *metaOutput = [[AVCaptureMetadataOutput alloc] init];
    
    if ([captureSession canAddOutput:metaOutput]) {
        [captureSession addOutput:metaOutput];
        
        NSArray *metaTypes = @[AVMetadataObjectTypeFace];
        //这个必须要在addoutput之后添加
        metaOutput.metadataObjectTypes = metaTypes;
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        [metaOutput setMetadataObjectsDelegate:self queue:mainQueue];
    }
    
    // 9.获取音频输入与输出连接，用于分辨音视频数据
    _audioConnection = [audioOutput connectionWithMediaType:AVMediaTypeAudio];
    
    // 10.添加视频预览图层
    AVCaptureVideoPreviewLayer *previedLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previedLayer.frame = [UIScreen mainScreen].bounds;
    //[self.view.layer insertSublayer:previedLayer atIndex:0];
    [self.view.layer addSublayer:previedLayer];
    _previedLayer = previedLayer;
    
    // 11.启动会话
    [captureSession startRunning];
}

- (void)setupLayer
{
    _aLayer = [CALayer layer];
    _aLayer.frame = _previedLayer.frame;
    _aLayer.sublayerTransform = CATransform3DMakePerspective(1000);
    [self.view.layer addSublayer:_aLayer];
    

    _faceLayers = [NSMutableDictionary dictionary];
    
}

static CATransform3D CATransform3DMakePerspective(CGFloat eyePosition)
{
    CATransform3D t = CATransform3DIdentity;
    
    t.m34 = -1.0 / eyePosition;
    
    return t;
}

// 指定摄像头方向获取摄像头
- (AVCaptureDevice *)getVideoDevice:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

#pragma mark - delegate

//采集到的数据(通过代理得到数据)
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
//    if (_audioConnection == connection) {
//        NSLog(@"采集到音频数据");
//    } else {
//        NSLog(@"采集到视频数据");
//    }
//    NSLog(@"%@",connection);
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self updateWithFaces:metadataObjects];
}


//切换摄像头
-(void) clickChangeButton
{
    // 获取当前设备方向
    AVCaptureDevicePosition curPosition = _currentVideoDeviceInput.device.position;
    
    // 获取需要改变的方向
    AVCaptureDevicePosition togglePosition = curPosition == AVCaptureDevicePositionFront?AVCaptureDevicePositionBack:AVCaptureDevicePositionFront;
    
    // 获取改变的摄像头设备
    AVCaptureDevice *toggleDevice = [self getVideoDevice:togglePosition];
    
    // 获取改变的摄像头输入设备
    AVCaptureDeviceInput *toggleDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:toggleDevice error:nil];
    
    // 移除之前摄像头输入设备
    [_session removeInput:_currentVideoDeviceInput];
    
    // 添加新的摄像头输入设备
    [_session addInput:toggleDeviceInput];
    
    // 记录当前摄像头输入设备
    _currentVideoDeviceInput = toggleDeviceInput;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 获取点击位置
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    // 把当前位置转换为摄像头点上的位置
    CGPoint cameraPoint = [_previedLayer captureDevicePointOfInterestForPoint:point];
    
    // 设置聚焦点光标位置
    [self setFocusCursorWithPoint:point];
    
    // 设置聚焦
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
-(void)setFocusCursorWithPoint:(CGPoint)point{
    self.focusCursorImageView.center=point;
    self.focusCursorImageView.transform=CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursorImageView.alpha=1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursorImageView.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursorImageView.alpha=0;
    }];
}
/**
 *  设置聚焦
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    
    AVCaptureDevice *captureDevice = _currentVideoDeviceInput.device;
    // 锁定配置
    [captureDevice lockForConfiguration:nil];
    
    // 设置聚焦
    if ([captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
    }
    if ([captureDevice isFocusPointOfInterestSupported]) {
        [captureDevice setFocusPointOfInterest:point];
    }
    
    // 设置曝光
    if ([captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
        [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
    }
    if ([captureDevice isExposurePointOfInterestSupported]) {
        [captureDevice setExposurePointOfInterest:point];
    }
    
    // 解锁配置
    [captureDevice unlockForConfiguration];
}

//返回
-(void)clickBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - face

- (void)updateWithFaces:(NSArray *)faces
{
    NSArray *transformeFaces = [self transformeFaces:faces];

    NSMutableArray *lostFaces = [_faceLayers.allKeys mutableCopy];

    for (AVMetadataFaceObject *face in transformeFaces) {

        [lostFaces removeObject:@(face.faceID)];

        CALayer *layer = _faceLayers[@(face.faceID)];
        if (layer == nil) {
            layer = [self makeFaceLayer];
            [_aLayer addSublayer:layer];
            _faceLayers[@(face.faceID)] = layer;
        }

        layer.transform = CATransform3DIdentity;
        layer.frame = face.bounds;
        
        //偏转角   yaw  angle
        if (face.hasYawAngle) {
            CATransform3D t = [self transformForYawAngle:face.yawAngle];
            
            layer.transform = CATransform3DConcat(layer.transform, t);
        }
        //斜倾角  roll angle
        if (face.hasRollAngle) {
            CATransform3D t = [self transformForRollAngle:face.rollAngle];
            
            layer.transform = CATransform3DConcat(layer.transform, t);
        }
        
    }

    for (NSNumber *faceID in lostFaces) {
        CALayer *layer = _faceLayers[faceID];
        [layer removeFromSuperlayer];
        [_faceLayers removeObjectForKey:faceID];
    }
}

- (NSArray *)transformeFaces:(NSArray *)faces
{
    NSMutableArray *muarray = [NSMutableArray array];
    
    for (AVMetadataFaceObject *face in faces) {
        AVMetadataObject *transformFace = [_previedLayer transformedMetadataObjectForMetadataObject:face];
        
        [muarray addObject:transformFace];
    }
    
    return muarray;
}

- (CALayer *)makeFaceLayer
{
    CALayer *layer = [CALayer layer];
    
    layer.borderColor = [UIColor redColor].CGColor;
    layer.borderWidth = 2.0f;
    
    //layer.contents = (id)[UIImage imageNamed:@"111.png"].CGImage;
    
    return layer;
}

- (CATransform3D)transformForYawAngle:(CGFloat)yawAngle
{
    //转弧度
    CGFloat yawAngleRadian = [self degreeToRadian:yawAngle];
    
    CATransform3D t = CATransform3DMakeRotation(yawAngleRadian, 0, -1.0, 0);
    
    return CATransform3DConcat(t, [self orientationTransform]);
}

- (CATransform3D)transformForRollAngle:(CGFloat)rollAngle
{
    CGFloat roll = [self degreeToRadian:rollAngle];
    
    return CATransform3DMakeRotation(roll, 0, 0, 1.0);
}

//角度转弧度
- (CGFloat)degreeToRadian:(CGFloat)degree
{
    return degree * M_PI / 180;
}

- (CATransform3D)orientationTransform
{
    CGFloat angle = 0.0;
    
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case UIDeviceOrientationLandscapeRight:
            angle = -M_PI/2.0f;
            break;
        case UIDeviceOrientationLandscapeLeft:
            angle = M_PI/2.0f;
            break;
        default:
            break;
    }
    return CATransform3DMakeRotation(angle, 0, 0, 1.0f);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

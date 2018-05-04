//
//  YYFPSLabel.h
//  YYKitExample
//
//    运用Demo
//    @property (nonatomic, strong) YYFPSLabel *fpsLabel;
//
//    _fpsLabel = [YYFPSLabel new];
//    [_fpsLabel sizeToFit];
//    _fpsLabel.y = 100;
//    _fpsLabel.x = 10;
//    _fpsLabel.alpha = 1;
//    [self.view addSubview:_fpsLabel];
//
//  Created by ibireme on 15/9/3.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Show Screen FPS...
 
 The maximum fps in OSX/iOS Simulator is 60.00.
 The maximum fps on iPhone is 59.97.
 The maxmium fps on iPad is 60.0.
 */
@interface YYFPSLabel : UILabel

@end

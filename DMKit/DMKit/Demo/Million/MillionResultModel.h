//
//  MillionResultModel.h
//  DMKit
//
//  Created by iMac-03 on 2020/7/10.
//  Copyright © 2020 呆木出品. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MillionResultModel : NSObject

@property (nonatomic , assign) BOOL isWin;          ///< 是否赢了
@property (nonatomic , assign) double ratioOfWin;   ///< 输赢比例
@property (nonatomic , assign) double oldMoney;     ///< 玩之前的金额
@property (nonatomic , assign) double inRatio;      ///< 透出比例
@property (nonatomic , assign) double inMoney;      ///< 投入金额
@property (nonatomic , assign) double changeMoney;  ///< 变动金额
@property (nonatomic , assign) double resultMoney;  ///< 最终金额

@end



//
//  PwdDictVC.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/3/28.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "PwdDictVC.h"

@interface PwdDictVC ()

@property (nonatomic , strong) NSMutableArray *muarray;

@property (nonatomic , strong) NSArray *datas;

@property (nonatomic , copy) NSArray *resultDatas;


@end

@implementation PwdDictVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *btn1 = [UIButton new];
    [btn1 setTitle:@"Start" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(50, 100, 150, 50);
    [btn1 addTarget:self action:@selector(clickBtn1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];

    _muarray = [NSMutableArray array];
    
    _datas = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
}

- (void)createResult
{
    NSMutableArray * muarray = [NSMutableArray array];
    for (int i = 0 ; i < _datas.count; i++)
    {
        NSString *str1 = _datas[i];
        for (int j = 0 ;j < _resultDatas.count; j++)
        {
            NSString *str2 = _resultDatas[j];
            [muarray addObject:[NSString stringWithFormat:@"%@%@",str1,str2]];
        }
        if (_resultDatas.count == 0) {
            [muarray addObject:[NSString stringWithFormat:@"%@",str1]];
        }
    }
    _resultDatas = [muarray copy];
}


- (void)clickBtn1
{
    NSLog(@"begin");
    long long count = 1;

    while (count < 5) {
        
        [self createResult];
        
        NSLog(@"count: %ld",[_resultDatas count]);
        
        NSString *resultStr = [_resultDatas componentsJoinedByString:@"\n"];
        NSString *path = [NSString stringWithFormat:@"/Users/xianwangdoudianzixinxiyouxiangongsi/Desktop/Allabc%02lld.txt",count] ;
        
        BOOL isOK = [resultStr writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        NSLog(@"write : %d",isOK);
        
        count ++;
    }
    
    NSLog(@"count: %lld",count);
    
    NSString *resultStr = [_resultDatas componentsJoinedByString:@"\n"];
    NSString *path = @"/Users/xianwangdoudianzixinxiyouxiangongsi/Desktop/Allabc.txt";
    
    BOOL isOK = [resultStr writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"write : %d",isOK);
    
    NSLog(@"end");
}

- (void)createAllDate
{
    NSLog(@"begin");
    long long count = 0;
    
    NSTimeInterval time = 0;
    
    NSDate *maxDate = [NSDate dateFromString:@"20300101" withFormat:@"yyyyMMdd"];
    NSTimeInterval maxTime = [maxDate timeIntervalSince1970];
    
    NSTimeInterval oneDay = 3600 * 24;
    
    while (time < maxTime) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        
        [_muarray addObject:[date getStringWithFormat:@"yyMd"]];
        [_muarray addObject:[date getStringWithFormat:@"yyMMdd"]];
        [_muarray addObject:[date getStringWithFormat:@"yyyyMMdd"]];
        [_muarray addObject:[date getStringWithFormat:@"yyyy.MM.dd"]];
        [_muarray addObject:[date getStringWithFormat:@"yyyy-MM-dd"]];
        [_muarray addObject:[date getStringWithFormat:@"yyyy/MM/dd"]];
        [_muarray addObject:[date getStringWithFormat:@"yyyy_MM_dd"]];
        
        time += oneDay;
        count ++;
    }
    
    NSLog(@"count: %lld",count);
    
    NSString *resultStr = [_muarray componentsJoinedByString:@"\n"];
    NSString *path = @"/Users/xianwangdoudianzixinxiyouxiangongsi/Desktop/AllDate.txt";
    
    BOOL isOK = [resultStr writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"write : %d",isOK);
    
    NSLog(@"end");
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"收到内存警告");
}



@end

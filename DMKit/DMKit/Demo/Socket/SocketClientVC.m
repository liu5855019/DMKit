//
//  Socket.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/1/4.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "SocketClientVC.h"
#import <sys/Socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface SocketClientVC ()

@property (nonatomic , assign) int socket;

@end

@implementation SocketClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.mainTitleLabel.text = @"socket 客户端";
    
    
    if ([self setupSocketWithPort:12344 addr:@"192.168.100.111"]) {
        [self read:^(NSString *msg) {
            NSLog(@"%@",msg);
        }];
    }
}

- (BOOL)setupSocketWithPort:(NSInteger)port addr:(NSString *)addr
{
    //1.创建socket
    
    //    af：一个地址描述。目前仅支持AF_INET格式，也就是说ARPA Internet地址格式。
    //    type：指定socket类型TCP（SOCK_STREAM）和UDP（SOCK_DGRAM）。
    //    protocol：指定协议。套接口所用的协议。如调用者不想指定，可用0。常用的协议有，IPPROTO_TCP、IPPROTO_UDP、IPPROTO_STCP、IPPROTO_TIPC等，它们分别对应TCP传输协议、UDP传输协议、STCP传输协议、TIPC传输协议。
    
    int clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    
    if (clientSocket > 0) {
        _socket = clientSocket;
        //NSLog(@"创建socket成功:%d",clientSocket);
        [DMTools showToastAtWindow:[NSString stringWithFormat:@"创建socket成功:%d",clientSocket]];
        
    } else {
        //NSLog(@"创建socket失败:%d",clientSocket);
        [DMTools showToastAtWindow:[NSString stringWithFormat:@"创建socket失败:%d",clientSocket]];
        return NO;
    }
    
    //终端创建服务器命令   nc -lk 12345
    //2.连接到服务器
    
    
    struct sockaddr_in serverAddr;
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(port);
    serverAddr.sin_addr.s_addr = inet_addr(addr.UTF8String);
    //    s：标识一个未连接socket
    //    name：指向要连接套接字的sockaddr结构体的指针
    //    namelen：sockaddr结构体的字节长度
    int connectResult = connect(clientSocket, (const struct sockaddr *)&serverAddr, sizeof(serverAddr));
    
    if (connectResult == 0) {
        [DMTools showToastAtWindow:[NSString stringWithFormat:@"连接服务器成功"]];
    }else{
        [DMTools showToastAtWindow:[NSString stringWithFormat:@"连接服务器失败:%d",connectResult]];
        return NO;
    }
    
    return YES;
}



- (void)send:(NSString *)sendMsg
{
    size_t sendLen = send(_socket, sendMsg.UTF8String, strlen(sendMsg.UTF8String), 0);
    
    NSLog(@"发送%ld字节",sendLen);
}

-(void) read:(void (^)(NSString *msg))readAction
{
   
    WeakObj(self); dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL rs = YES;
        while (rs) {
            uint8_t buffer[1024];
            NSLog(@"开始接收数据...");
            ssize_t recvLen = recv(selfWeak.socket, buffer, sizeof(buffer), 0);
            NSLog(@"接收数据完毕...");
            if(recvLen < 0){
                // 由于是非阻塞的模式,所以当buflen为EAGAIN时,表示当前缓冲区已无数据可读
                // 在这里就当作是该次事件已处理
                if(recvLen == EAGAIN){
                    break;
                }else{
                    rs = 0;
                    break;
                }
            }else if(recvLen == 0){
                // 这里表示对端的socket已正常关闭.(服务器关闭)
                rs = 0;
                break;
            }
            
            
            // 从buffer中读取服务器发回的数据
            // 按照服务器返回的长度，从 buffer 中，读取二进制数据，建立 NSData 对象
            NSData *data = [NSData dataWithBytes:buffer length:recvLen];
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (readAction) {
                    readAction(str);
                }
            });
        }
    });
}

- (void)dealloc
{
    int result = close(_socket);
    
    if (result == noErr) {
        NSLog(@"关闭socket成功!");
    }else{
        NSLog(@"关闭socket失败:%d",result);
    }
    
    MyLog(@"over...");
}


@end

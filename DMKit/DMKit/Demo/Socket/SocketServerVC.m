//
//  SocketServerVC.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/1/5.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "SocketServerVC.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>


@interface SocketServerVC ()

@property (nonatomic , assign) int socket;

@end

@implementation SocketServerVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.mainTitleLabel.text = @"socket 服务端";
    
    [self performSelector:@selector(setup) withObject:nil afterDelay:0.1];
    
}

- (void)setup
{
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
    
    int serverSocket = socket(AF_INET, SOCK_STREAM, 0);
    
    if (serverSocket > 0) {
        _socket = serverSocket;
        NSLog(@"创建socket成功:%d",serverSocket);
    } else {
        NSLog(@"创建socket失败:%d",serverSocket);
        return NO;
    }
    
    //2.bind
    struct sockaddr_in serverAddr;
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(port);
    serverAddr.sin_addr.s_addr = inet_addr(addr.UTF8String);
    int bindResult = bind(_socket, (const struct sockaddr *)&serverAddr, sizeof(serverAddr));
    if (bindResult == noErr) {
        NSLog(@"bind 成功!");
        [DMTools showToastAtWindow:@"bind 成功!"];
    }else{
        NSLog(@"bind 失败!");
        [DMTools showToastAtWindow:@"bind 失败!"];
        return NO;
    }
    
    //3.listen
    //sockfd：用于标识一个已捆绑未连接套接口的描述字。
    //backlog：等待连接队列的最大长度。
    bindResult = listen(_socket, 100);
    
    if (bindResult == noErr) {
        NSLog(@"listen 成功!");
        [DMTools showToastAtWindow:@"listen 成功!"];
    }else{
        NSLog(@"listen 失败!");
        [DMTools showToastAtWindow:@"listen 失败!"];
        return NO;
    }
    
    //4.accept
    
    BACK(^{
        int acceptResult = accept(_socket, NULL, NULL);
        
        if (acceptResult >= 0) {
            [DMTools showToastAtWindow:@"accept 成功!"];
        }else{
            [DMTools showToastAtWindow:@"accept 失败!"];
        }
    });
    
    
    
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

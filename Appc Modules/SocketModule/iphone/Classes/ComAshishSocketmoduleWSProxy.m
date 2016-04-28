/**
 * SocketModule
 *
 * Created by Your Name
 * Copyright (c) 2015 Your Company. All rights reserved.
 */

#import "ComAshishSocketmoduleWSProxy.h"

@implementation ComAshishSocketmoduleWSProxy

-(id)init
{
    connected = FALSE;
    return [super init];
}

-(void)dealloc
{
     WS = nil;
}

#pragma WebSocket Delegate

-(void)webSocketDidOpen:(SRWebSocket*)webSocket
{
    connected  = YES;
    
    if ([self _hasListeners:@"open"]) {
        [self fireEvent:@"open" withObject:nil];
    }
}

-(void)webSocket:(SRWebSocket*)webSocket didFailWithError:(NSError*)error
{
    connected  = NO;
    
    if ([self _hasListeners:@"error"]) {
        NSDictionary* event = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"reconnect",@"advice",
                               [error description],@"error",
                               nil];
        
        [self fireEvent:@"error" withObject:event];
    }
}

-(void)webSocket:(SRWebSocket*)webSocket didCloseWithCode:(NSInteger)code reason:(NSString*)reason wasClean:(BOOL)wasClean
{
    connected = NO;
    
    if ([self _hasListeners:@"close"]) {
        NSDictionary* event = [NSDictionary dictionaryWithObjectsAndKeys:NUMINTEGER(code),@"code",reason,@"reason",nil];
        [self fireEvent:@"close" withObject:event];
    }
}

-(void)webSocket:(SRWebSocket*)webSocket didReceiveMessage:(id)data
{
    if ([self _hasListeners:@"message"]) {
        NSDictionary* event = [NSDictionary dictionaryWithObjectsAndKeys:data,@"data",nil];
        [self fireEvent:@"message" withObject:event];
    }
}

#pragma Public API

-(void)open:(id)args
{
    if (WS || connected) {
        return;
    }
    
    id url = nil;
    ENSURE_ARG_AT_INDEX(url, args, 0, NSString);
    id protocols = nil;
    ENSURE_ARG_OR_NIL_AT_INDEX(protocols, args, 1, NSArray);
    id headers = nil;
    ENSURE_ARG_OR_NIL_AT_INDEX(headers, args, 2, NSDictionary);
    
    NSLog(@"[INFO] SocketURL: %@",url);
    NSLog(@"[INFO] SocketProtocols: %@",protocols);
    NSLog(@"[INFO] SocketHeaders: %@",headers);
    
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    if (headers) {
        for (NSString* header in headers) {
            [req setValue:[headers objectForKey:header] forHTTPHeaderField:header];
        }
    }
    
    WS = [[SRWebSocket alloc] initWithURLRequest:req protocols:protocols];
    WS.delegate = self;
    [WS open];
}


- (void)reconnect:(id)args
{
    WS.delegate = nil;
    [WS close];
    
    id url = nil;
    ENSURE_ARG_AT_INDEX(url, args, 0, NSString);
    id protocols = nil;
    ENSURE_ARG_OR_NIL_AT_INDEX(protocols, args, 1, NSArray);
    
    WS = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] protocols:protocols];
    WS.delegate = self;
    [WS open];
}

-(void)close:(id)args
{
    if (WS && connected) {
        [WS close];
    }
}

-(void)send:(id)msg
{
    ENSURE_SINGLE_ARG(msg, NSString);
    
    if (WS && connected) {
        [WS send:msg];
    }
}

-(NSNumber*)readyState
{
    if (WS == nil) {
        return [NSNumber numberWithInt:-1];
    }
    return [NSNumber numberWithInt:WS.readyState];
}


@end

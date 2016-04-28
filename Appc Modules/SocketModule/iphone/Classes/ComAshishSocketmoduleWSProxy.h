/**
 * SocketModule
 *
 * Created by Your Name
 * Copyright (c) 2015 Your Company. All rights reserved.
 */

#import "TiProxy.h"
#import "SRWebSocket.h"

@interface ComAshishSocketmoduleWSProxy : TiProxy <SRWebSocketDelegate>
{
    SRWebSocket* WS;
    BOOL connected;
}

@end

/**
 * appcgoogleplusios
 *
 * Created by Your Name
 * Copyright (c) 2015 Your Company. All rights reserved.
 */

#import "TiModule.h"
#import <GooglePlus/GooglePlus.h>


@protocol TiFGooglePlusSigninStateListener
@required
-(void)signin;
-(void)signout;
@end

@interface ComAshishnigamAppcgoogleplusModule : TiModule<GPPSignInDelegate>
{
    BOOL loggedIn;
    NSString *clientId;
    NSMutableArray *scopeArr;
    
    KrollCallback *successCallback;
    KrollCallback *errorCallback;
}




-(BOOL)isLoggedIn:(id)args;
-(void)signin:(id)args;
-(void)signout:(id)args;
-(void)disconnect:(id)args;
@end

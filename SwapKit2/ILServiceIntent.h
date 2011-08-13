//
//  ILServiceRequest.h
//  SwapKit2
//
//  Created by ∞ on 10/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILServiceIntent : NSObject

@property(copy, nonatomic) void (^provideDataBlock)(UIPasteboard* pb);
@property(copy, nonatomic) NSString* requestedAction;

@end

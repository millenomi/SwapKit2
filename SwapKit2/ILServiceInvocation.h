//
//  ILServiceInvocation.h
//  SwapKit2
//
//  Created by ∞ on 11/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ILServiceIntent.h"
#import "ILServiceDefinition.h"

@interface ILServiceInvocation : NSObject {
@private
    ILServiceIntent* intent;
}

- (id)initWithIntent:(ILServiceIntent*) intent;

@property(nonatomic, readonly) UIPasteboard* sendingPasteboard;
@property(nonatomic, readonly) NSSet* applicableServices;

@property(nonatomic, retain) ILServiceDefinition* service;

@property(nonatomic, readonly) BOOL canInvoke;
- (BOOL) invoke;

@end

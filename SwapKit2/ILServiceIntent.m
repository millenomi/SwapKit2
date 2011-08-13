//
//  ILServiceRequest.m
//  SwapKit2
//
//  Created by ∞ on 10/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ILServiceIntent.h"

@implementation ILServiceIntent

@synthesize provideDataBlock, requestedAction;

- (void) dealloc;
{
    [provideDataBlock release];
    [requestedAction release];
    [super dealloc];
}

@end

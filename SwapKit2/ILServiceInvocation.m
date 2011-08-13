//
//  ILServiceInvocation.m
//  SwapKit2
//
//  Created by ∞ on 11/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ILServiceInvocation.h"
#import "ILServicesSet.h"

@implementation ILServiceInvocation

@synthesize sendingPasteboard;
@synthesize applicableServices;
@synthesize service;

- (id)initWithIntent:(ILServiceIntent*) i;
{
    self = [super init];
    if (self) {
        intent = [i retain];
    }
    
    return self;
}

- (void)dealloc {
    [intent release];
    [applicableServices release];
    [service release];
    [sendingPasteboard release]; // TODO proper management.
    [super dealloc];
}

- (UIPasteboard *)sendingPasteboard;
{
    if (!sendingPasteboard) {
        sendingPasteboard = [UIPasteboard pasteboardWithUniqueName];
        sendingPasteboard.persistent = YES; // maybe later?
        
        NSAssert(intent.provideDataBlock, @"You must provide a data provider block for your message.");
        (intent.provideDataBlock)(sendingPasteboard);
    }
    
    return sendingPasteboard;
}

- (NSSet *)applicableServices;
{
    if (!applicableServices) {
        NSMutableSet* services = [NSMutableSet set];
        
        [[ILServicesSet sharedServicesSet] enumerateServiceDefinitionsWithBlock:^(ILServiceDefinition *definition, BOOL *stop) {
            
            BOOL isAppropriateForAction = !intent.requestedAction || [definition.supportedActions containsObject:intent.requestedAction];
            
            BOOL isAppropriateForTypes = NO;
            for (NSString* type in self.sendingPasteboard.pasteboardTypes) {
                if ([definition.supportedInputTypes containsObject:type]) {
                    isAppropriateForTypes = YES;
                    break;
                }
            }
            
            if (isAppropriateForTypes && isAppropriateForAction)
                [services addObject:definition];
        }];
        
        applicableServices = [services copy];
    }
    
    return applicableServices;
}

- (BOOL)canInvoke;
{
    return self.service && [self.applicableServices containsObject:self.service];
}

- (BOOL) invoke;
{
    NSAssert(self.service, @"You must have picked a service to invoke to.");
    NSAssert([self.applicableServices containsObject:self.service], @"The service must be appropriate for this pasteboard.");
    
    UIPasteboard* pb = self.sendingPasteboard;
    NSString* URLScheme = self.service.URLScheme;
    
    NSString* pasteboardName = [NSMakeCollectable(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef) pb.name, NULL, (CFStringRef) @"+/&=|,()", kCFStringEncodingUTF8)) autorelease];
    
    NSURL* invocationURL = [NSURL URLWithString:
                            [NSString stringWithFormat:@"%@:%@", URLScheme, pasteboardName]
                            ];
    
    if (!invocationURL)
        return NO;
    
    if (![[invocationURL scheme] isEqualToString:URLScheme])
        return NO;
    
    return [[UIApplication sharedApplication] openURL:invocationURL];
}

@end

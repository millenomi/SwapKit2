//
//  ILServiceInvocationController.h
//  SwapKit2
//
//  Created by ∞ on 12/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ILServiceInvocation.h"
@class ILServicePicker;
@protocol ILServiceInvocationControllerDelegate;

@interface ILServiceInvocationController : NSObject {
@private
    ILServiceInvocation* invocation;
}

- (id)initWithInvocation:(ILServiceInvocation*) i;
- (BOOL) proceed;

@property(nonatomic, assign) id <ILServiceInvocationControllerDelegate> delegate;

@end


@protocol ILServiceInvocationControllerDelegate <NSObject>

- (void) presentModalViewController:(UIViewController*) vc forInvocationController:(ILServiceInvocationController*) ctl;
- (void) dismissModalViewController:(UIViewController*) vc forInvocationController:(ILServiceInvocationController*) ctl;

- (void) presentPopoverController:(UIPopoverController*) pc forInvocationController:(ILServiceInvocationController*) ctl;
- (void) dismissPopoverController:(UIPopoverController*) pc forInvocationController:(ILServiceInvocationController*) ctl;

@end

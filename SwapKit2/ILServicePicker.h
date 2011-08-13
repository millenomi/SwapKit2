//
//  ILServicePicker.h
//  SwapKit2
//
//  Created by ∞ on 11/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ILServiceInvocation.h"
@protocol ILServicePickerDelegate;

@interface ILServicePicker : UITableViewController {
@private
    ILServiceInvocation* invocation;
    NSCache* iconsCache;
}

- (id)initWithInvocation:(ILServiceInvocation*) i;

@property(nonatomic, assign) id <ILServicePickerDelegate> delegate;
@property(nonatomic, assign) BOOL displayedInPopover;

@end

@protocol ILServicePickerDelegate <NSObject>

- (void) servicePicker:(ILServicePicker*) picker didPickService:(ILServiceDefinition*) service;
- (void) servicePickerDidCancel:(ILServicePicker*) picker;

@end
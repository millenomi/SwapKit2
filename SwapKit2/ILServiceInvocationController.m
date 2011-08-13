//
//  ILServiceInvocationController.m
//  SwapKit2
//
//  Created by ∞ on 12/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ILServiceInvocationController.h"
#import "ILServicePicker.h"

@interface ILServiceInvocationController () <ILServicePickerDelegate, UIPopoverControllerDelegate>

@property(retain, nonatomic) ILServicePicker* displayedPicker;
@property(retain, nonatomic) UIPopoverController* pickerPopover;

@end


@implementation ILServiceInvocationController

@synthesize delegate, displayedPicker, pickerPopover;

- (id)initWithInvocation:(ILServiceInvocation*) i;
{
    self = [super init];
    if (self) {
        invocation = [i retain];
    }
    
    return self;
}

- (void)dealloc {
    self.pickerPopover = nil;
    self.displayedPicker = nil;
    
    [invocation release];
    [super dealloc];
}

- (void)setPickerPopover:(UIPopoverController *) p;
{
    if (pickerPopover != p) {
        if (pickerPopover.delegate == self)
            pickerPopover.delegate = nil;
        
        [pickerPopover autorelease];
        pickerPopover = [p retain];
        
        pickerPopover.delegate = self;
    }
}

- (void)setDisplayedPicker:(ILServicePicker *) d;
{
    if (displayedPicker != d) {
        if (displayedPicker.delegate == self)
            displayedPicker.delegate = nil;
        
        [displayedPicker autorelease];
        displayedPicker = [d retain];
        
        displayedPicker.delegate = self;
    }
}

- (BOOL) proceed;
{
    while (!invocation.canInvoke) {
        if (!invocation.service) {
            NSSet* services = invocation.applicableServices;
            if ([services count] == 0) {

                // no service can be used to perform this invocation.
                // show an alert.
                
                break;
            
            } else if ([services count] == 1) {
                invocation.service = [services anyObject];
                continue;
            } else {
                
                // more than one service fits the bill.
                // is the picker already out? then break.
                if (self.displayedPicker)
                    break;
                
                // show the picker.
                
                ILServicePicker* picker = nil; // TODO
                
                picker.delegate = self;
                self.displayedPicker = picker;
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

                    picker.displayedInPopover = YES;

                    UIPopoverController* popover = [[[UIPopoverController alloc] initWithContentViewController:picker] autorelease];
                    self.pickerPopover = popover;
                    
                    [self.delegate presentPopoverController:popover forInvocationController:self];
                    
                } else {
                    [self.delegate presentModalViewController:picker forInvocationController:self];
                }
                
                break;
                
            }
        }
    }
    
    if (invocation.canInvoke) {
        if (self.displayedPicker) {
            // dismiss it.
        }
        
        return [invocation invoke];
    } else {
        return NO;
    }
}

// Picker handling.

- (void)servicePicker:(ILServicePicker *)picker didPickService:(ILServiceDefinition *)service;
{
    invocation.service = service;
    
    if (self.pickerPopover)
        [self.delegate dismissPopoverController:pickerPopover forInvocationController:self];
    else
        [self.delegate dismissModalViewController:picker forInvocationController:self];
    
    self.displayedPicker = nil;
    self.pickerPopover = nil;
    
    [self proceed];
}

- (void)servicePickerDidCancel:(ILServicePicker *)picker;
{
    if (self.pickerPopover)
        [self.delegate dismissPopoverController:pickerPopover forInvocationController:self];
    else
        [self.delegate dismissModalViewController:picker forInvocationController:self];
    
    self.displayedPicker = nil;
    self.pickerPopover = nil;    
}

@end

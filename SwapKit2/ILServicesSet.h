//
//  ILServicesSet.h
//  SwapKit2
//
//  Created by ∞ on 11/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILServiceDefinition.h"

@interface ILServicesSet : NSObject {
@private
    UIPasteboard* servicesPasteboard;
}

+ sharedServicesSet;

@property(readonly, nonatomic) NSSet* allServiceDefinitions;
- (void) enumerateServiceDefinitionsWithBlock:(void(^)(ILServiceDefinition* definition, BOOL* stop)) block;

- (void) removeServiceDefinitionsMatchingBlock:(BOOL(^)(ILServiceDefinition* definition)) block;

- (void) addServiceWithDefinition:(ILServiceDefinition*) definition;

@end


@interface ILServiceDefinition (ILServiceDefinitionValidity)

@property(readonly, nonatomic, getter = isValid) BOOL valid;

@end

//
//  ILServicesSet.m
//  SwapKit2
//
//  Created by ∞ on 11/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ILServicesSet.h"

#define kILServicesRegistrationPasteboardName @"net.infinite-labs.swapkit2.services"
#define kILServiceRegistrationType @"net.infinite-labs.swapkit2.service"

@interface ILServicesSet ()

- (void) enumeratePossibleServiceDefinitionsWithBlock:(void(^)(NSInteger index, id value, BOOL* stop)) block;

@end

@implementation ILServicesSet

+ (id)sharedServicesSet;
{
    static id me = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        me = [self new];
    });
    
    return me;
}

- (id)init
{
    self = [super init];
    if (self) {
        servicesPasteboard = [UIPasteboard pasteboardWithName:kILServicesRegistrationPasteboardName create:YES];
        servicesPasteboard.persistent = YES;
    }
    
    return self;
}

// Definitions are stored in the reg pasteboard as NSDictionaries in different items, using the kILServiceRegistrationType, well, type.
// See the ILServiceDefinition class for the specific format to use.
- (NSSet*) allServiceDefinitions;
{
    NSMutableSet* services = [NSMutableSet set];
    
    [self enumerateServiceDefinitionsWithBlock:^(ILServiceDefinition *definition, BOOL *stop) {
        [services addObject:definition];
    }];
    
    return services;
}

- (void) enumeratePossibleServiceDefinitionsWithBlock:(void(^)(NSInteger index, id value, BOOL* stop)) block;
{
    NSIndexSet* indexes = [servicesPasteboard itemSetWithPasteboardTypes:[NSArray arrayWithObject:kILServiceRegistrationType]];
    
    NSInteger index = [indexes firstIndex];
    
    BOOL stop = NO;
    
    while (index != NSNotFound) {
        id value = [servicesPasteboard valuesForPasteboardType:kILServiceRegistrationType inItemSet:[NSIndexSet indexSetWithIndex:index]];
        
        block(index, value, &stop);
        
        if (stop)
            break;
        
        index = [indexes indexGreaterThanIndex:index];
    }

}

- (void) enumerateServiceDefinitionsWithBlock:(void(^)(ILServiceDefinition* definition, BOOL* stop)) block;
{
    NSMutableIndexSet* invalidIndexes = [NSMutableIndexSet indexSet];
        
    __block BOOL skipInvokingBlock = NO;

    [self enumeratePossibleServiceDefinitionsWithBlock:^(NSInteger index, id definitionDictionary, BOOL *stop) {
        
        if (![definitionDictionary isKindOfClass:[NSDictionary class]])
            return;
        
        ILServiceDefinition* definition = [[[ILServiceDefinition alloc] initWithDefinitionDictionary:definitionDictionary] autorelease];
        
        if (definition && definition.valid) {
            if (!skipInvokingBlock)
                block(definition, &skipInvokingBlock);
        } else {
            [invalidIndexes addIndex:index];
        }

    }];
    
    NSMutableArray* items = [[servicesPasteboard.items mutableCopy] autorelease];
    [items removeObjectsAtIndexes:invalidIndexes];
    servicesPasteboard.items = items;
}

- (void)addServiceWithDefinition:(ILServiceDefinition *)definition;
{
    __block BOOL shouldSkip = NO;
    [self enumerateServiceDefinitionsWithBlock:^(ILServiceDefinition* otherDefinition, BOOL *stop) {
        
        if ([otherDefinition.identifier isEqualToString:definition.identifier] && otherDefinition.version >= definition.version) {
            shouldSkip = YES;
            *stop = YES;
        }
        
    }];
    
    if (shouldSkip)
        return;
    
    [self removeServiceDefinitionsMatchingBlock:^BOOL(ILServiceDefinition *otherDefinition) {
        return [otherDefinition.identifier isEqualToString:definition.identifier];
    }];
    
    NSDictionary* definitionDictionary = [definition dictionaryRepresentation];
    
    [servicesPasteboard addItems:
     [NSArray arrayWithObject:
      [NSDictionary dictionaryWithObject:definitionDictionary forKey:kILServiceRegistrationType]
      ]
     ];
}

- (void)removeServiceDefinitionsMatchingBlock:(BOOL (^)(ILServiceDefinition *))block;
{
    NSMutableIndexSet* toRemove = [NSMutableIndexSet indexSet];
   
    [self enumeratePossibleServiceDefinitionsWithBlock:^(NSInteger index, id definitionDictionary, BOOL *stop) {
        
        if (![definitionDictionary isKindOfClass:[NSDictionary class]])
            return;
        
        ILServiceDefinition* definition = [[[ILServiceDefinition alloc] initWithDefinitionDictionary:definitionDictionary] autorelease];
        
        if (definition && definition.valid) {
            
            if (block(definition))
                [toRemove addIndex:index];
            
        } else {
            [toRemove addIndex:index];
        }

    }];
    
    NSMutableArray* items = [[servicesPasteboard.items mutableCopy] autorelease];
    [items removeObjectsAtIndexes:toRemove];
    servicesPasteboard.items = items;
}

@end


@implementation ILServiceDefinition (ILServiceDefinitionValidity)

- (BOOL)isValid;
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@:", self.URLScheme]];
    return url && [[UIApplication sharedApplication] canOpenURL:url];
}

@end

//
//  ILServiceDefinition.h
//  SwapKit2
//
//  Created by ∞ on 11/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILServiceDefinition : NSObject <NSCopying, NSMutableCopying> {
@protected
    NSUInteger version;
    NSString* identifier, * URLScheme;
    NSSet* supportedActions, * supportedInputTypes;
    NSData* listIconData;
    NSDictionary* localizedDisplayNames;
}

- (id) initWithDefinitionDictionary:(NSDictionary*) dictionary;

@property(readonly, nonatomic) NSUInteger version;

@property(copy, readonly, nonatomic) NSString* identifier;
@property(copy, readonly, nonatomic) NSString* URLScheme;

@property(copy, readonly, nonatomic) NSDictionary* localizedDisplayNames;
- (NSString*) displayNameForPreferredLanguage;

@property(copy, readonly, nonatomic) NSSet* supportedActions;
@property(copy, readonly, nonatomic) NSSet* supportedInputTypes;

@property(readonly, nonatomic) NSDictionary* dictionaryRepresentation;

@property(copy, readonly, nonatomic) NSData* listIconData;

@end


@interface ILMutableServiceDefinition : ILServiceDefinition

@property(nonatomic) NSUInteger version;

@property(copy, nonatomic) NSDictionary* localizedDisplayNames;

@property(copy, nonatomic) NSString* identifier;
@property(copy, nonatomic) NSString* URLScheme;

@property(copy, nonatomic) NSSet* supportedActions;
@property(copy, nonatomic) NSSet* supportedInputTypes;

@property(copy, nonatomic) NSData* listIconData;

@end
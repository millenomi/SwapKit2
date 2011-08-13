//
//  ILServiceDefinition.m
//  SwapKit2
//
//  Created by ∞ on 11/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ILServiceDefinition.h"

#import "ILSchema.h"

@interface ILServiceDefinitionSchema : ILSchema
@property(nonatomic, readonly) NSNumber* version;
@property(nonatomic, readonly) NSString* identifier;
@property(nonatomic, readonly) NSString* URLScheme;
@property(nonatomic, readonly) NSArray* supportedActions;
@property(nonatomic, readonly) NSArray* supportedInputTypes;
@property(nonatomic, readonly) NSData* listIconData;
@property(nonatomic, readonly) NSDictionary* localizedDisplayNames;
@end

@implementation ILServiceDefinitionSchema

@dynamic version, identifier, URLScheme, supportedActions, supportedInputTypes, listIconData, localizedDisplayNames;

- (Class) validClassForVersionKey { return [NSNumber class]; }
- (Class) validClassForIdentifierKey { return [NSString class]; }
- (Class) validClassForURLSchemeKey { return [NSString class]; }
- (Class) validClassForSupportedActionsKey { return [NSArray class]; }
- (Class) validClassForSupportedInputTypesKey { return [NSArray class]; }
- (Class) validClassForListIconDataKey { return [NSData class]; }

- (Class) validClassForValuesOfLocalizedDisplayNamesDictionaryKey { return [NSString class]; }

@end


@implementation ILServiceDefinition

@synthesize version, identifier, URLScheme, supportedActions, supportedInputTypes, listIconData, localizedDisplayNames;

- (id) initWithDefinitionDictionary:(NSDictionary*) dictionary;
{
    self = [super init];
    if (self) {
        ILServiceDefinitionSchema* schema = [[ILServiceDefinitionSchema alloc] initWithValue:dictionary error:NULL];
        if (!schema) {
            [self release];
            return nil;
        }
        
        version = [schema.version unsignedIntegerValue];
        identifier = [schema.identifier copy];
        URLScheme = [schema.URLScheme copy];
        supportedActions = [NSSet setWithArray:schema.supportedActions];
        supportedInputTypes = [NSSet setWithArray:schema.supportedInputTypes];
        listIconData = [schema.listIconData copy];
    }
    
    return self;
}

- (id) initWithServiceDefinition:(ILServiceDefinition*) def;
{
    self = [super init];
    
    if ([def class] == [ILServiceDefinition class]) {
        [def retain];
        [self release];
        return def;
    }
    
    if (self) {
    
        version = def.version;
        identifier = [def.identifier copy];
        URLScheme = [def.URLScheme copy];
        supportedActions = [def.supportedActions copy];
        supportedInputTypes = [def.supportedInputTypes copy];
        listIconData = [def.listIconData copy];
    
    }
    
    return self;
}

- (void)dealloc;
{
    [identifier release];
    [URLScheme release];
    [supportedActions release];
    [supportedInputTypes release];
    [listIconData release];
    [localizedDisplayNames release];
    
    [super dealloc];
}

- (NSDictionary *)dictionaryRepresentation;
{
    NSAssert(identifier && URLScheme && supportedInputTypes && supportedActions && listIconData && localizedDisplayNames, @"All properties must be correctly set to produce a dictionary representation.");
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            
            identifier, @"identifier",
            URLScheme, @"URLScheme",
            [supportedInputTypes allObjects], @"supportedInputTypes",
            [supportedActions allObjects], @"supportedActions",
            listIconData, @"listIconData",
            localizedDisplayNames, @"localizedDisplayNames",
            
            nil];
}

- (id)copyWithZone:(NSZone *)zone;
{
    return [[ILServiceDefinition allocWithZone:zone] initWithServiceDefinition:self];
}

- (id)mutableCopyWithZone:(NSZone *)zone;
{
    return [[[ILMutableServiceDefinition allocWithZone:zone] initWithServiceDefinition:self] autorelease];
}

- (NSString *)displayNameForPreferredLanguage;
{
    for (NSString* lang in [NSLocale preferredLanguages]) {
        NSString* name = [self.localizedDisplayNames objectForKey:lang];
        if (name)
            return name;
    }
    
    return [self.localizedDisplayNames objectForKey:@"en"];
}

@end


@implementation ILMutableServiceDefinition

- (id)init {
    self = [super init];
    if (self) {
        self.supportedInputTypes = [NSSet set];
        self.supportedActions = [NSSet set];
        self.localizedDisplayNames = [NSDictionary dictionary];
    }
    return self;
}

- (NSUInteger)version { return [super version]; }
- (void)setVersion:(NSUInteger) v;
{
    version = v;
}

- (NSString *)identifier { return [super identifier]; }
- (void)setIdentifier:(NSString *) i;
{
    NSAssert(i, @"You can't set this property to nil.");
    [identifier autorelease];
    identifier = [i copy];
}

- (NSString *)URLScheme { return [super URLScheme]; }
- (void)setURLScheme:(NSString *) u;
{
    NSAssert(u, @"You can't set this property to nil.");
    [URLScheme release];
    URLScheme = [u copy];
}

- (NSSet *)supportedActions { return [super supportedActions]; }
- (void)setSupportedActions:(NSSet *) s;
{
    NSAssert(s, @"You can't set this property to nil.");
    [supportedActions release];
    supportedActions = [s copy];
}

- (NSSet *)supportedInputTypes { return [super supportedInputTypes]; }
- (void)setSupportedInputTypes:(NSSet *) s;
{
    NSAssert(s, @"You can't set this property to nil.");
    [supportedInputTypes release];
    supportedInputTypes = [s copy];    
}

- (NSData *)listIconData { return [super listIconData]; }
- (void)setListIconData:(NSData *)l;
{
    NSAssert(l, @"You can't set this property to nil.");
    [listIconData release];
    listIconData = [l copy];
}

- (NSDictionary *)localizedDisplayNames { return [super localizedDisplayNames]; }
- (void)setLocalizedDisplayNames:(NSDictionary *) l;
{
    NSAssert(l, @"You can't set this property to nil.");
    [localizedDisplayNames release];
    localizedDisplayNames = [l copy];
}

@end

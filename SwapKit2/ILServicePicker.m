//
//  ILServicePicker.m
//  SwapKit2
//
//  Created by ∞ on 11/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ILServicePicker.h"

@interface ILServicePicker ()
@property(readonly, nonatomic) NSArray* orderedServices;
@end


static NSString* ILServicePickerShortenedAndQuotedStringFromString(NSString* str) {
    if ([str length] > 40)
        str = [[str substringToIndex:40] stringByAppendingFormat:@"%C", 0x2026 /* HORIZONTAL ELLIPSIS */];
    
    return [NSString stringWithFormat:@"%C%@%C", 0x201C /* LEFT DOUBLE QUOTATION MARK */, str, 0x201D /* RIGHT DOUBLE QUOTATION MARK */];
}

@implementation ILServicePicker

@synthesize delegate, displayedInPopover;

- (id)initWithInvocation:(ILServiceInvocation*) i;
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        invocation = [i retain];
        iconsCache = [NSCache new];
    }
    return self;
}

- (void) dealloc;
{
    [invocation release];
    [iconsCache release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    NSString* str = invocation.sendingPasteboard.string;
    if (str)
        return ILServicePickerShortenedAndQuotedStringFromString(str);
    
    return @"Selection"; // TODO
}

- (NSArray*) orderedServices;
{
    // TODO
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.orderedServices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
#define kILServicePickerServiceCell @"ILServicePickerServiceCell"
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kILServicePickerServiceCell];
    
    if (!cell) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kILServicePickerServiceCell] autorelease];
        
    }
    
    ILServiceDefinition* service = [self.orderedServices objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = [service displayNameForPreferredLanguage];
    
    UIImage* i = [iconsCache objectForKey:service.identifier];
    if (!i)
        [iconsCache setObject:[UIImage imageWithData:service.listIconData] forKey:service.identifier];
    
    cell.imageView.image = [UIImage imageWithData:service.listIconData];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
}

@end

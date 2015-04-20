//
//  TYMTextDescriptor.m
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/14/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "TYMTextDescriptor.h"
#import "TYMTextRenderer.h"
#import "NSDictionary+TYMPresentationKit.h"

NSString *const kTYMTextDescriptorContentKey = @"content";


@implementation TYMTextDescriptor

#pragma mark - Accessors

@synthesize content = _content;


#pragma mark - TYMDescriptor

+ (NSString *)descriptorTypeName {
    return @"text";
}


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if ((self = [super initWithDictionary:dictionary])) {
        NSArray *arrayOfStrings = [dictionary tym_objectForKey:kTYMTextDescriptorContentKey];
        _content = [arrayOfStrings componentsJoinedByString:@"\n"];
    }
    return self;
}


- (NSDictionary *)customDescriptorInfo {
    return @{
        kTYMTextDescriptorContentKey: self.content
    };
}


- (Class)rendererClass {
    return [TYMTextRenderer class];
}

@end

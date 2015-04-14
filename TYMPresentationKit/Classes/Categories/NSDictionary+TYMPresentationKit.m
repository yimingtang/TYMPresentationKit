//
//  NSDictionary+TYMPresentationKit.m
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/13/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "NSDictionary+TYMPresentationKit.h"

@implementation NSDictionary (TYMPresentationKit)

- (id)tym_objectForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == [NSNull null]) {
        object = nil;
    }
    return object;
}

@end

//
//  TYMImageDescriptor.m
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/14/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "TYMImageDescriptor.h"
#import "TYMImageRenderer.h"
#import "NSDictionary+TYMPresentationKit.h"

NSString *const kTYMImageDescriptorURLKey = @"image_url";

@implementation TYMImageDescriptor

#pragma mark - Accessors

@synthesize imageURLString = _imageURLString;


#pragma mark - TYMDescriptor

+ (NSString *)descriptorTypeName {
    return @"image";
}


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if ((self = [super initWithDictionary:dictionary])) {
        _imageURLString = [dictionary tym_objectForKey:kTYMImageDescriptorURLKey];
    }
    return self;
}


- (NSDictionary *)customDescriptorInfo {
    return @{
        kTYMImageDescriptorURLKey: self.imageURLString
    };
}


- (Class)rendererClass {
    return [TYMImageRenderer class];
}

@end

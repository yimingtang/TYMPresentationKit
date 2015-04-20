//
//  TYMRenderer.m
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/20/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "TYMRenderer.h"

@implementation TYMRenderer

#pragma mark - Accessors

@synthesize descriptor = _descriptor;


#pragma mark - Class Methods

+ (instancetype)rendererWithDescriptor:(TYMDescriptor *)descriptor {
    return [[self alloc] initWithDescriptor:descriptor];
}


#pragma mark - NSObject

- (instancetype)initWithDescriptor:(TYMDescriptor *)descriptor {
    if ((self = [super init])) {
        _descriptor = descriptor;
    }
    return self;
}


#pragma mark - Public Methods

- (UIView *)renderView {
    // Subclasses must override this method
    return [[UIView alloc] init];
}

@end

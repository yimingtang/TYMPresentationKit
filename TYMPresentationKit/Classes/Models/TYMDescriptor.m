//
//  TYMDescriptor.m
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/13/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "TYMDescriptor.h"
#import "TYMButtonDescriptor.h"
#import "TYMImageDescriptor.h"
#import "TYMTextDescriptor.h"
#import "TYMTextFieldDescriptor.h"
#import "NSDictionary+TYMPresentationKit.h"

@implementation TYMDescriptor

#pragma mark - Accessors

@synthesize delegate = _delegate;
@synthesize subDescriptors = _subDescriptors;
@synthesize superDescriptor = _superDescriptor;


#pragma mark - Class Cluster

+ (instancetype)descriptorWithDictionary:(NSDictionary *)dictionary {
    NSString *type = [dictionary tym_objectForKey:@"type"];
    
    if ([type isEqualToString:@"text"]) {
        return [[TYMTextDescriptor alloc] initWithDictionary:dictionary];
    }
    
    else if ([type isEqualToString:@"image"]) {
        return [[TYMImageDescriptor alloc] initWithDictionary:dictionary];
    }
    
    else if ([type isEqualToString:@"button"]) {
        return [[TYMButtonDescriptor alloc] initWithDictionary:dictionary];
    }
    
    else if ([type isEqualToString:@"text_field"]) {
        return [[TYMButtonDescriptor alloc] initWithDictionary:dictionary];
    }
    
    else {
        return nil;
    }
}


+ (NSString *)descriptorName {
    // Subclasses must override this method
    return @"abstract";
}


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    // Subclasses must override this method
    return [super init];
}


- (UIView *)renderedView {
    // Subclasses must override this method
    return nil;
}


- (NSDictionary *)dictionaryRepresentation {
    // Subclasses must override this method
    return @{@"type": [[self class] descriptorName]};
}

@end

//
//  TYMSlide.m
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/13/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "TYMSlide.h"
#import "TYMSlideRenderer.h"
#import "NSDictionary+TYMPresentationKit.h"

NSString *const kTYMSlideAuthorKey = @"author";
NSString *const kTYMSlideNoteKey = @"note";
NSString *const kTYMSlideRevisionKey = @"revision";
NSString *const kTYMSlideNextSlideNameKey = @"next";
NSString *const kTYMSlidePreviousSlideNameKey = @"previous";


@implementation TYMSlide

#pragma mark - Accessors

@synthesize note = _note;
@synthesize author = _author;
@synthesize revision = _revision;
@synthesize nextSlideName = _nextSlideName;
@synthesize previousSlideName = _previousSlideName;


#pragma mark - TYMDescriptor

+ (NSString *)descriptorTypeName {
    return @"slide";
}


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if ((self = [super initWithDictionary:dictionary])) {
        _author = [dictionary tym_objectForKey:kTYMSlideAuthorKey];
        _note = [dictionary tym_objectForKey:kTYMSlideNoteKey];
        _revision = [dictionary tym_objectForKey:kTYMSlideRevisionKey];
        _nextSlideName = [dictionary tym_objectForKey:kTYMSlideNextSlideNameKey];
        _previousSlideName = [dictionary tym_objectForKey:kTYMSlidePreviousSlideNameKey];
    }
    return self;
}


- (NSDictionary *)customDescriptorInfo {
    return @{
        kTYMSlideAuthorKey: self.author,
        kTYMSlideRevisionKey: self.revision,
        kTYMSlideNoteKey: self.note,
        kTYMSlidePreviousSlideNameKey: self.previousSlideName ? : [NSNull null],
        kTYMSlideNextSlideNameKey: self.nextSlideName ? : [NSNull null],
    };
}


- (Class)rendererClass {
    return [TYMSlideRenderer class];
}


#pragma mark - Public

- (TYMSlide *)nextSlide {
    return [TYMSlide descriptorNamed:self.nextSlideName];
}


- (TYMSlide *)previousSlide {
    return [TYMSlide descriptorNamed:self.previousSlideName];
}

@end

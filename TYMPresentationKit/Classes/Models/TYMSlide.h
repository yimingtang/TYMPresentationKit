//
//  TYMSlide.h
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/13/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "TYMDescriptor.h"

extern NSString *const kTYMSlideAuthorKey;
extern NSString *const kTYMSlideRevisionKey;
extern NSString *const kTYMSlideNoteKey;
extern NSString *const kTYMSlideNextSlideNameKey;
extern NSString *const kTYMSlidePreviousSlideNameKey;

@interface TYMSlide : TYMDescriptor

@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *revision;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *previousSlideName;
@property (nonatomic, copy) NSString *nextSlideName;

- (TYMSlide *)nextSlide;
- (TYMSlide *)previousSlide;

@end

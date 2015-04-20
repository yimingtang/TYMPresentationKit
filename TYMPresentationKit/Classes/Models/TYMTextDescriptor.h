//
//  TYMTextDescriptor.h
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/14/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "TYMDescriptor.h"

extern NSString *const kTYMTextDescriptorContentKey;

@interface TYMTextDescriptor : TYMDescriptor <UITextViewDelegate>

@property (nonatomic, copy) NSString *content;

@end

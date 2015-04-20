//
//  TYMRenderer.h
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/20/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

@class TYMDescriptor;

@interface TYMRenderer : NSObject

@property (nonatomic, readonly) TYMDescriptor *descriptor;

+ (instancetype)rendererWithDescriptor:(TYMDescriptor *)descriptor;
- (instancetype)initWithDescriptor:(TYMDescriptor *)descriptor;
- (UIView *)renderView;

@end

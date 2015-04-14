//
//  TYMDescriptor.h
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/13/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

@import Foundation;

@class TYMPage;
@protocol TYMDescriptorDelegate;

@interface TYMDescriptor : NSObject

@property (nonatomic, weak) id<TYMDescriptorDelegate> delegate;
@property (nonatomic, weak) TYMPage *page;

+ (instancetype)descriptorWithDictionary:(NSDictionary *)dictionary;
+ (NSString *)descriptorName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (UIView *)renderedView;
- (NSDictionary *)dictionaryRepresentation;

@end


@protocol TYMDescriptorDelegate <NSObject>
@end

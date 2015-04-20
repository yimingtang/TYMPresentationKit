//
//  TYMTextRenderer.m
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/20/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "TYMTextRenderer.h"
#import "TYMTextDescriptor.h"

@implementation TYMTextRenderer

#pragma mark - Accessors

- (TYMTextDescriptor *)textDescriptor {
    return (TYMTextDescriptor *)self.descriptor;
}


#pragma mark - TYMRenderer

- (UIView *)renderView {
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];
    textView.scrollEnabled = NO;
    textView.editable = NO;
    textView.delegate = [self textDescriptor];
    textView.dataDetectorTypes = UIDataDetectorTypeLink | UIDataDetectorTypeAddress | UIDataDetectorTypePhoneNumber;
    textView.attributedText = [self attributedText];
    return textView;
}


#pragma mark - Private Methods

- (NSAttributedString *)attributedText {
    return [[NSAttributedString alloc] initWithString:[[self textDescriptor] content]];
}

@end

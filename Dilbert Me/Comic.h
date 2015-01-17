//
//  Comic.h
//  Dilbert Me
//
//  Created by Weiran Zhang on 17/01/2015.
//  Copyright (c) 2015 Weiran Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@interface Comic : RLMObject <QLPreviewItem>

- (instancetype)initWithDate:(NSDate *)date image:(NSImage *)image;

@property NSString *identifier;
@property NSDate *date;
@property NSImage *image;
@property NSString *imageCacheURLString;
@property BOOL seen;
@property (nonatomic, strong) NSURL *imageCacheURL;

@end
RLM_ARRAY_TYPE(Comic)
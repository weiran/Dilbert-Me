//
//  Comic.h
//  Dilbert Me
//
//  Created by Weiran Zhang on 17/01/2015.
//  Copyright (c) 2015 Weiran Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@interface Comic : NSObject <QLPreviewItem>

- (instancetype)initWithDate:(NSDate *)date image:(NSImage *)image;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSImage *image;
@property (nonatomic, strong) NSURL *imageCacheURL;

@end

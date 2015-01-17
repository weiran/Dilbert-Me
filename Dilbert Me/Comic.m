//
//  Comic.m
//  Dilbert Me
//
//  Created by Weiran Zhang on 17/01/2015.
//  Copyright (c) 2015 Weiran Zhang. All rights reserved.
//

#import "Comic.h"

#import <YLMoment/YLMoment.h>

@implementation Comic

- (instancetype)initWithDate:(NSDate *)date image:(NSImage *)image {
    self = [super init];
    if (self) {
        self.date = date;
        self.image = image;
        self.identifier = [[YLMoment momentWithDate:self.date] format:@"yyyyMMdd"];
        self.seen = NO;
        [self saveToCache];
    }
    return self;
}

+ (NSArray *)ignoredProperties {
    return @[@"imageCacheURL", @"image"];
}

+ (NSString *)primaryKey {
    return @"identifier";
}

- (void)saveToCache {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *cachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:bundleName];
    
    NSData *imageData = [self.image TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    imageData = [imageRep representationUsingType:NSPNGFileType properties:nil];
    
    NSString *fileName = [NSString stringWithFormat:@"dilbert_%@.png", self.identifier];
    NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
    [imageData writeToFile:filePath atomically:NO];
    
    self.imageCacheURLString = [NSString stringWithFormat:@"file://%@", filePath];
    _imageCacheURL = nil;
}

- (NSURL *)imageCacheURL {
    if (!_imageCacheURL) {
        _imageCacheURL = [NSURL URLWithString:self.imageCacheURLString];
    }
    return _imageCacheURL;
}

- (NSURL *)previewItemURL {
    return self.imageCacheURL;
}

- (NSString *)previewItemTitle {
    YLMoment *moment = [YLMoment momentWithDate:self.date];
    NSString *formattedDate = nil;
    if (moment.day == [YLMoment now].day) {
        formattedDate = @"Today";
    } else {
        formattedDate = [moment format:@"EEEE, dd MMMM"];
    }
    return [NSString stringWithFormat:@"Daily Dilbert - %@", formattedDate];
}

@end

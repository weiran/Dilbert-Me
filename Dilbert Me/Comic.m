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
        [self saveToCache];
    }
    return self;
}

- (void)saveToCache {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *cachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:bundleName];
    
    NSData *imageData = [self.image TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    imageData = [imageRep representationUsingType:NSPNGFileType properties:nil];
    
    YLMoment *momentDate = [YLMoment momentWithDate:self.date];
    NSString *fileName = [momentDate format:@"'dilbert_'yyyyMMdd'.png'"];
    
    NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
    [imageData writeToFile:filePath atomically:NO];
    
    self.imageCacheURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", filePath]];
}

- (NSURL *)previewItemURL {
    return self.imageCacheURL;
}

- (NSString *)previewItemTitle {
    return @"Dilbert";
}


@end

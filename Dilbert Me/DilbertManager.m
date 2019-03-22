//
//  DilbertManager.m
//  Dilbert Me
//
//  Created by Weiran Zhang on 17/01/2015.
//  Copyright (c) 2015 Weiran Zhang. All rights reserved.
//

#import "DilbertManager.h"

#import "Comic.h"

#import <AFNetworking/AFNetworking.h>
#import "AFNetworking+PromiseKit.h"
#import <HTMLReader/HTMLReader.h>
#import <YLMoment/YLMoment.h>
#import <QuickLook/QuickLook.h>

@interface DilbertManager ()
@property (strong) QLPreviewPanel *previewPanel;
@property (strong) RLMResults *comics;
@property (strong) AFHTTPSessionManager *sessionManager;
@end

@implementation DilbertManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.comics = [[Comic allObjects] sortedResultsUsingKeyPath:@"identifier" ascending:NO];
        self.sessionManager = [AFHTTPSessionManager manager];
        self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

- (Comic *)latestComic {
    return [self.comics firstObject];
}

- (AnyPromise *)update {
    return [self.sessionManager GET:@"http://dilbert.com" parameters:nil]
    .then(^(id responseObject, NSURLSessionTask *task) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        HTMLDocument *document = [HTMLDocument documentWithString:html];
        NSArray *comicItems = [document nodesMatchingSelector:@".comic-item"];
        
        NSMutableArray *promises = [NSMutableArray array];
        for (HTMLElement *element in comicItems) {
            [promises addObject:[self parseComic:element]];
        }
        
        return PMKWhen(promises);
    })
    .then(^(NSArray* comics) {
        Comic *latestComic = [self.comics firstObject];
        Comic *newestComic = [comics firstObject];
        BOOL hasNewerComics = ![latestComic.identifier isEqualToString:newestComic.identifier];
        
        return PMKManifold(comics, hasNewerComics);
    })
    .then(^(NSArray* comics, BOOL hasNewerComics) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addOrUpdateObjects:comics];
        [realm commitWriteTransaction];
        return PMKManifold(hasNewerComics);
    })
    .catch(^(NSError *error){
        NSLog(@"error: %@", error.localizedDescription);
        NSLog(@"original operation: %@", error.userInfo[AFHTTPRequestOperationErrorKey]);
    });
}


- (AnyPromise *)parseComic:(HTMLElement *)element {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        // get date
        NSString *comicDateString = [[element firstNodeMatchingSelector:@"date span:first-of-type"] textContent];
        NSDate *comicDate = [[YLMoment momentWithDateAsString:comicDateString] date];
        
        // get image
        HTMLElement *todaysComicImgElement = [element firstNodeMatchingSelector:@"img.img-comic"];
        NSString *todaysComicImageURL = [todaysComicImgElement attributes][@"src"];
        
        [self.sessionManager GET:todaysComicImageURL parameters:nil]
        .then(^(id responseObject) {
            NSImage *image = [[NSImage alloc] initWithData:responseObject];
            Comic *comic = [[Comic alloc] initWithDate:comicDate image:image];
            resolve(comic);
        })
        .catch(^(NSError *error){
            resolve(error);
        });
    }];
}


#pragma mark - Quick Look panel support

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel {
    return YES;
}

- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel {
    self.previewPanel = panel;
    panel.delegate = self;
    panel.dataSource = self;
}

- (void)endPreviewPanelControl:(QLPreviewPanel *)panel {
    self.previewPanel = nil;
}


#pragma mark - QLPreviewPanelDataSource

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel {
    return self.comics.count;
}

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index {
    return self.comics[index];
}


#pragma mark - QLPreviewPanelDelegate

- (NSRect)previewPanel:(QLPreviewPanel *)panel sourceFrameOnScreenForPreviewItem:(id <QLPreviewItem>)item {
    return CGRectMake(0, 0, 900, 280);
}

@end

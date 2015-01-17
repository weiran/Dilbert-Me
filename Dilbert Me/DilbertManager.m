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
#import <PromiseKit-AFNetworking/AFNetworking+PromiseKit.h>
#import <HTMLReader/HTMLReader.h>
#import <YLMoment/YLMoment.h>
#import <QuickLook/QuickLook.h>

@interface DilbertManager ()
@property (strong) QLPreviewPanel *previewPanel;
@property (strong) RLMResults *comics;
@end

@implementation DilbertManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.comics = [Comic allObjects];
    }
    return self;
}

- (PMKPromise *)getLatest {
    return [AFHTTPRequestOperation request:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dilbert.com/"]]]
    .then(^(id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        HTMLDocument *document = [HTMLDocument documentWithString:html];
        NSArray *comicItems = [document nodesMatchingSelector:@".comic-item"];
        
        NSMutableArray *promises = [NSMutableArray array];
        for (HTMLElement *element in comicItems) {
            [promises addObject:[DilbertManager parseComic:element]];
        }
        return [PMKPromise when:promises];
    })
    .then(^(NSArray* comics) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addOrUpdateObjectsFromArray:comics];
        [realm commitWriteTransaction];
    })
    .catch(^(NSError *error){
        NSLog(@"error: %@", error.localizedDescription);
        NSLog(@"original operation: %@", error.userInfo[AFHTTPRequestOperationErrorKey]);
    });
}


+ (PMKPromise *)parseComic:(HTMLElement *)element {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        // get date
        NSString *comicDateString = [[element firstNodeMatchingSelector:@"h3.comic-item-date span a date"] textContent];
        NSDate *comicDate = [[YLMoment momentWithDateAsString:comicDateString] date];
        
        // get image
        HTMLElement *todaysComicImgElement = [element firstNodeMatchingSelector:@"img.img-comic"];
        NSString *todaysComicImageURL = [todaysComicImgElement attributes][@"src"];
        
        [AFHTTPRequestOperation request:[NSURLRequest requestWithURL:[NSURL URLWithString:todaysComicImageURL]]]
        .then(^(id responseObject) {
            NSImage *image = [[NSImage alloc] initWithData:responseObject];
            Comic *comic = [[Comic alloc] initWithDate:comicDate image:image];
            fulfill(comic);
        })
        .catch(^(NSError *error){
            reject(error);
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

//- (BOOL)previewPanel:(QLPreviewPanel *)panel handleEvent:(NSEvent *)event {
//    // redirect all key down events to the table view
//    if ([event type] == NSKeyDown)
//    {
//        [self.downloadsTableView keyDown:event];
//        return YES;
//    }
//    return NO;
//}

// This delegate method provides the rect on screen from which the panel will zoom.
- (NSRect)previewPanel:(QLPreviewPanel *)panel sourceFrameOnScreenForPreviewItem:(id <QLPreviewItem>)item {
    return CGRectMake(0, 0, 280, 900);
    //    NSInteger index = [self.downloads indexOfObject:item];
    //    if (index == NSNotFound)
    //    {
    //        return NSZeroRect;
    //    }
    //
    //    NSRect iconRect = [self.downloadsTableView frameOfCellAtColumn:0 row:index];
    //
    //    // check that the icon rect is visible on screen
    //    NSRect visibleRect = [self.downloadsTableView visibleRect];
    //
    //    if (!NSIntersectsRect(visibleRect, iconRect))
    //    {
    //        return NSZeroRect;
    //    }
    //
    //    // convert icon rect to screen coordinates
    //    iconRect = [self.downloadsTableView convertRectToBase:iconRect];
    //    iconRect.origin = [[self.downloadsTableView window] convertBaseToScreen:iconRect.origin];
    //
    //    return iconRect;
}
//
//// this delegate method provides a transition image between the table view and the preview panel
////
//- (id)previewPanel:(QLPreviewPanel *)panel transitionImageForPreviewItem:(id <QLPreviewItem>)item contentRect:(NSRect *)contentRect
//{
//    DownloadItem *downloadItem = (DownloadItem *)item;
//    
//    return downloadItem.iconImage;
//}

@end

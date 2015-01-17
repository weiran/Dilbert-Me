//
//  Comic.m
//  Dilbert Me
//
//  Created by Weiran Zhang on 17/01/2015.
//  Copyright (c) 2015 Weiran Zhang. All rights reserved.
//

#import "Comic.h"

#import <QuickLook/QuickLook.h>
#import <YLMoment/YLMoment.h>

@interface Comic (QLPreviewItem) <QLPreviewItem>
@property (strong) QLPreviewPanel *previewPanel;
@end

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
    
    self.imageCacheURL = [NSURL URLWithString:[NSString stringWithFormat:@"file:///%@", filePath]];
}

- (NSURL *)previewItemURL {
    return self.imageCacheURL;
}

- (NSString *)previewItemTitle {
    return @"Dilbert";
}



#pragma mark - Quick Look panel support

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel {
    return YES;
}

- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel {
    // This document is now responsible of the preview panel
    // It is allowed to set the delegate, data source and refresh panel.
    //
    self.previewPanel = panel;
    panel.delegate = self;
    panel.dataSource = self;
}

- (void)endPreviewPanelControl:(QLPreviewPanel *)panel {
    // This document loses its responsisibility on the preview panel
    // Until the next call to -beginPreviewPanelControl: it must not
    // change the panel's delegate, data source or refresh it.
    //
    self.previewPanel = nil;
}


#pragma mark - QLPreviewPanelDataSource

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel {
//    return self.selectedDownloads.count;
    return 1;
}

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index {
//    return (self.selectedDownloads)[index];
    return self;
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
//- (NSRect)previewPanel:(QLPreviewPanel *)panel sourceFrameOnScreenForPreviewItem:(id <QLPreviewItem>)item
//{
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
//}
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

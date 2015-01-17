//
//  DilbertMenu.m
//  Dilbert Me
//
//  Created by Weiran Zhang on 17/01/2015.
//  Copyright (c) 2015 Weiran Zhang. All rights reserved.
//

#import "DilbertMenu.h"

#import "DilbertManager.h"
#import "Comic.h"

@interface DilbertMenu ()
@property (nonatomic, strong) DilbertManager *manager;

@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong) IBOutlet NSMenu *olderDilbertsMenu;
@end

@implementation DilbertMenu

- (instancetype)init {
    self = [super init];
    if (self) {
        NSNib *menuNib = [[NSNib alloc] initWithNibNamed:@"DilbertMenu" bundle:nil];
        [menuNib instantiateWithOwner:self topLevelObjects:nil];

        self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        [self.statusItem setMenu:self.statusMenu];
        [self.statusItem setTitle:@"D"];
        [self.statusItem setHighlightMode:YES];
        
        self.manager = [[DilbertManager alloc] init];
        [self.manager update];
    }
    return self;
}

- (IBAction)didPressTodaysDilbert:(id)sender {
    [[QLPreviewPanel sharedPreviewPanel] setDataSource:self.manager];
    if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) {
        [[QLPreviewPanel sharedPreviewPanel] orderOut:nil];
    } else {
        [[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFront:nil];
    }
}

- (IBAction)didPressQuit:(id)sender {
    [NSApp terminate:self];
}

@end

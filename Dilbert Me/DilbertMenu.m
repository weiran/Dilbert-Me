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

@interface DilbertMenu () <NSUserNotificationCenterDelegate>
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
        [self.statusItem setImage:[NSImage imageNamed:@"DilbertMenuBarIcon"]];
        [self.statusItem setAlternateImage:[NSImage imageNamed:@"DilbertMenuBarIconInverted"]];
        [self.statusItem setHighlightMode:YES];
        
        self.manager = [[DilbertManager alloc] init];
        [self checkForUpdate];
        
        NSInteger oneHour = 60 * 60;
        [NSTimer scheduledTimerWithTimeInterval:oneHour target:self selector:@selector(checkForUpdate) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)checkForUpdate {
    [self.manager update]
    .then(^(BOOL hasNewerComics) {
        if (hasNewerComics) {
            [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
            NSUserNotification *notification = [[NSUserNotification alloc] init];
            notification.title = @"Daily Dilbert";
            notification.informativeText = @"There's a new Daily Dilbert";
            notification.soundName = NSUserNotificationDefaultSoundName;
            [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        }
    });
}

- (void)showDilbert {
    [[QLPreviewPanel sharedPreviewPanel] setDataSource:self.manager];
    if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) {
        [[QLPreviewPanel sharedPreviewPanel] orderOut:nil];
    } else {
        [[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFront:nil];
    }}

- (IBAction)didPressTodaysDilbert:(id)sender {
    [self showDilbert];
}

- (IBAction)didPressQuit:(id)sender {
    [NSApp terminate:self];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    [self showDilbert];
}

@end

//
//  ViewController.m
//  Dilbert Me
//
//  Created by Weiran Zhang on 17/01/2015.
//  Copyright (c) 2015 Weiran Zhang. All rights reserved.
//

#import "ViewController.h"

#import "DilbertManager.h"
#import "Comic.h"

#import <QuickLook/QuickLook.h>
#import <Quartz/Quartz.h>

@interface ViewController ()
@property (nonatomic, strong) DilbertManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.manager = [[DilbertManager alloc] init];
    [self.manager getLatest]
    .then(^(Comic *comic) {
        [self.view.window makeFirstResponder:self.view];
        [[QLPreviewPanel sharedPreviewPanel] setDataSource:self.manager];
        if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) {
            [[QLPreviewPanel sharedPreviewPanel] orderOut:nil];
        } else {
            [[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFront:nil];
        }
    });
}

@end

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

#import <PromiseKit/PromiseKit.h>
#import <QuickLook/QuickLook.h>
#import <Quartz/Quartz.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    DilbertManager *manager = [[DilbertManager alloc] init];
    [manager getLatest]
    .then(^(Comic *comic) {
        [[QLPreviewPanel sharedPreviewPanel] setDataSource:comic];
        if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible])
        {
            [[QLPreviewPanel sharedPreviewPanel] orderOut:nil];
        }
        else
        {
            [[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFront:nil];
        }
        
    });
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end

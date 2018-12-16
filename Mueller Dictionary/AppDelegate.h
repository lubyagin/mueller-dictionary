//
//  AppDelegate.h
//  Mueller Dictionary for macOS
//
//  Created by Suvorov Vasily on 5/13/12.
//  Copyright (c) 2012 bazil.pro. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property NSArray *muellerArticles;
@property NSArray *customArticles;
@property NSSpeechSynthesizer *speeker;

@property IBOutlet NSSearchField *search;
@property IBOutlet NSTextView *display;

- (IBAction)go:(NSSearchField *)sender;

@end

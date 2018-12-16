//
//  AppDelegate.m
//  Mueller Dictionary
//
//  Created by Suvorov Vasily on 5/13/12.
//  Copyright (c) 2012 bazil.pro. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.speeker = [[NSSpeechSynthesizer alloc] initWithVoice:NULL];
    [self.display setFont:[NSFont fontWithName:@"Palatino" size:16]];

    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"mueller" ofType:@"txt"];
    NSString *text1 = [NSString stringWithContentsOfFile:path1 encoding:NSUTF8StringEncoding error:nil];
    _muellerArticles = [text1 componentsSeparatedByString:@"\n"];
	
	NSString *path2 = [[NSBundle mainBundle] pathForResource:@"custom" ofType:@"txt"];
	NSString *text2 = [NSString stringWithContentsOfFile:path2 encoding:NSUTF8StringEncoding error:nil];
	_customArticles = [text2 componentsSeparatedByString:@"\n"];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (NSString *)formatText:(NSString *)text {
    NSRange rng = [text rangeOfString:@"["];
    
    while (rng.location != NSNotFound) {
        
        NSString *str = [text substringToIndex:rng.location];
        rng = [text rangeOfString:@"]"];
        if (rng.location == NSNotFound) return text;
        
        str = [str stringByAppendingString:[text substringFromIndex:rng.location + 1]];
        
        text = str;
        rng = [text rangeOfString:@"["];
    }

    text = [text stringByReplacingOccurrencesOfString:@"_" withString:@""];

    text = [text stringByReplacingOccurrencesOfString:@" II" withString:@" \nII"];
    text = [text stringByReplacingOccurrencesOfString:@" IV" withString:@" \nIV"];
    text = [text stringByReplacingOccurrencesOfString:@" VI" withString:@" \nVI"];
    text = [text stringByReplacingOccurrencesOfString:@" IX" withString:@" \nIX"];
    text = [text stringByReplacingOccurrencesOfString:@" XI" withString:@" \nXI"];

    text = [text stringByReplacingOccurrencesOfString:@"> " withString:@") "];
    
    return text;
}

- (IBAction)go:(NSSearchField *)sender {
    self.display.string = @"";

    if (!sender.stringValue.length) return;
    
    if (sender.stringValue.length == 1)
        [sender setStringValue:[[sender stringValue] stringByAppendingString:@" "]];
    
    NSArray *dict = _muellerArticles;

    NSApplication *app = [NSApplication sharedApplication];
    [app.mainWindow setTitle:@"Mueller Dictionary"];

    if ([[sender stringValue] compare:@"zzz"] > 0) {
        dict = _customArticles;
        [app.mainWindow setTitle:@"Custom Dictionary"];
    }    

    for (id ob in dict) {
        NSString *str = ob;
        if (dict == _customArticles)
            str = [str stringByReplacingOccurrencesOfString:@"|" withString:@""];

        NSRange rng = [str rangeOfString:[sender stringValue] options:NSCaseInsensitiveSearch];

        if (rng.location == 0) {
            if (dict == _muellerArticles) str = [self formatText:str];
            self.display.string = [self.display.string stringByAppendingFormat:@"%@\n\n", str];
        }

    }

    // speech
    if ([[self.display string] length] && dict == _muellerArticles) {
        NSRange rng = [[self.display string] rangeOfString:@"  "];
        [sender setStringValue:[[self.display string] substringToIndex:rng.location]];
        [self.speeker startSpeakingString:[sender stringValue]];
    }
}

@end

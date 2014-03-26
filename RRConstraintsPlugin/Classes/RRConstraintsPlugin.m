//
//  RRConstraintsPlugin.m
//  RRConstraintsPlugin
//
//  Copyright (c) 2014 Rolandas Razma <rolandas@razma.lt>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
// grep -Rs "<className>" /Applications/Xcode.app/ | grep Binary
// class-dump -HISs -o Headers /Applications/Xcode.app/Contents/PlugIns/IDEInterfaceBuilderKit.ideplugin/Contents/MacOS/IDEInterfaceBuilderKit
//


#import "RRConstraintsPlugin.h"
#import "RRWelcomeWindowController.h"


static RRConstraintsPlugin *sharedPlugin;


@interface RRConstraintsPlugin ()

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) RRWelcomeWindowController *welcomeWindowController;

@end


@implementation RRConstraintsPlugin


+ (void)pluginDidLoad:(NSBundle *)plugin {
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];

    if ( [currentApplicationName isEqual:@"Xcode"] ) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}


+ (RRConstraintsPlugin *)sharedPlugin {
    return sharedPlugin;
}


#pragma mark -
#pragma mark RRConstraintsPlugin


- (id)initWithBundle:(NSBundle *)plugin {
    if ( (self = [super init]) ) {
        [self setBundle: plugin];

        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationDidFinishLaunchingNotification:)
                                                     name: NSApplicationDidFinishLaunchingNotification
                                                   object: [NSApplication sharedApplication]];

    }
    return self;
}


- (void)applicationDidFinishLaunchingNotification:(NSNotification *)notification {

    NSString *bundleVersion = [[self.bundle infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *oldBundleVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"RRConstraintsPlugin.CFBundleVersion"];
    
    if( ![oldBundleVersion isEqualToString:bundleVersion] ){
        if( !self.welcomeWindowController ){
            self.welcomeWindowController = [[RRWelcomeWindowController alloc] initWithBundle:self.bundle];
        }
        
        [[self.welcomeWindowController window] makeKeyAndOrderFront:self];
        
        [[NSUserDefaults standardUserDefaults] setObject:bundleVersion forKey:@"RRConstraintsPlugin.CFBundleVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}


@end

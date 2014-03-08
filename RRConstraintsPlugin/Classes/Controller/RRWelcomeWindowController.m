//
//  RRWelcomeWindowController.m
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

#import "RRWelcomeWindowController.h"
@import WebKit;


@interface RRWelcomeWindowController ()

@end


@implementation RRWelcomeWindowController {
    __weak IBOutlet WebView *_webView;
}


#pragma mark -
#pragma mark RRWelcomeWindowController


- (id)initWithBundle:(NSBundle *)bundle {
    if (self = [super initWithWindowNibName:@"RRWelcomeWindowController"]) {
        
        // Add verion number to title
        NSString *bundleVersion = [[bundle infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [self.window setTitle: [self.window.title stringByAppendingFormat:@" v%@", bundleVersion]];

        // Load changelog
        [[_webView mainFrame] loadData: [NSData dataWithContentsOfURL: [bundle URLForResource:@"index" withExtension:@"html"]]
                              MIMEType: @"text/html"
                      textEncodingName: @"UTF-8"
                               baseURL: [bundle resourceURL]];
    }
    return self;
}


#pragma mark -
#pragma mark WebPolicyDelegate


- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id <WebPolicyDecisionListener>)listener {
    
    if( [request.URL.scheme isEqualToString:@"file"] ){
        [listener use];
    }else{
        [[NSWorkspace sharedWorkspace] openURL: [request URL]];
    }
    
}


@end

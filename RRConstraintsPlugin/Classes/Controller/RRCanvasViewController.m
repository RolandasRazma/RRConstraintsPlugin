//
//  RRCanvasViewController.m
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

#import "IBCanvasViewController.h"
#import "IDEMenuKeyBindingSet.h"
#import "IDEWorkspaceTabController.h"


@interface RRCanvasViewController : NSViewController <IBCanvasViewController>

@end


@implementation RRCanvasViewController


#pragma mark -
#pragma mark NSObject


+ (void)load {
    [NSClassFromString(@"IBCanvasViewController") importMethodsFromClass:[self class] exchangeImplementationsPrefix:"rr_"];
}


#pragma mark -
#pragma mark IBCanvasViewController


- (void)rr_editorDidChangeSelection:(IBEditor *)selection {
    [self rr_editorDidChangeSelection:selection];

    if( [self.selectedMembers count] == 1 ){
        id selectedObject = [self.selectedMembers firstObject];
        if( [selectedObject isKindOfClass: NSClassFromString(@"IBLayoutConstraint")] ){
            IDEMenuKeyBindingSet *menuKeyBindingSet = [NSClassFromString(@"IDEMenuKeyBindingSet") defaultKeyBindingSet];
            NSMenuItem *menuItem = [menuKeyBindingSet menuItemForCommandIdentifier: @"Xcode.InterfaceBuilderKit.InspectorCategory.Attributes"];
            [[self activeWorkspaceTabController] showInspectorWithChoiceFromSender:menuItem];
        }
    }
}


@end

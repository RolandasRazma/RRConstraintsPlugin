//
//  RRLayoutConstraintItemInspectorProperty.m
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

#import "IBLayoutConstraintItemInspectorProperty.h"
#import "IBAbstractDocumentEditor.h"
#import "IBHybridStructureViewController.h"
#import "IBStoryboardStructureViewController.h"
#import "IBOutlineViewController.h"
#import "IBNavigationOutlineViewController.h"
#import "IBStoryboardNavigationOutlineViewController.h"
#import "IBDocument.h"
#import "IBOutlineView.h"
#import <objc/runtime.h>


@interface RRLayoutConstraintItemInspectorProperty : NSViewController <IBLayoutConstraintItemInspectorProperty>

@end


@implementation RRLayoutConstraintItemInspectorProperty


#pragma mark -
#pragma mark NSObject


+ (void)load {
    [NSClassFromString(@"IBLayoutConstraintItemInspectorProperty") importMethodsFromClass:[self class] exchangeImplementationsPrefix:"rr_"];
}


#pragma mark -
#pragma mark IBLayoutConstraintItemInspectorProperty


- (void)rr_didStartRollingOverItemInspectorBackgroundView:(IBLayoutConstraintItemInspectorBackgroundView *)view {

    Ivar itemKeyPathIvar = class_getInstanceVariable([self class], "_itemKeyPath");
    NSArray *objects = [self allValuesForKeyPath: object_getIvar(self, itemKeyPathIvar)];
    [self outlineViewsShouldHlighteObjects:objects];
    
    [self rr_didStartRollingOverItemInspectorBackgroundView:view];
}


- (void)rr_didFinishRollingOverItemInspectorBackgroundView:(IBLayoutConstraintItemInspectorBackgroundView *)view {
    [self outlineViewsShouldHlighteObjects:nil];
    [self rr_didFinishRollingOverItemInspectorBackgroundView:view];
}


#pragma mark -
#pragma mark RRLayoutConstraintItemInspectorProperty


- (void)outlineViewsShouldHlighteObjects:(NSArray *)objects {
    IBDocument *document = [self inspectedDocument];
    
    NSArray *visibleDocumentEditorControllers = [NSClassFromString(@"IBAbstractDocumentEditor") visibleDocumentEditorControllersFromBackToFrontInDocument:document];

    IBStructureViewController *structureViewController = [[visibleDocumentEditorControllers lastObject] structureViewController];

    IBNavigationOutlineViewController *navigationOutlineViewController;
    if( [structureViewController isKindOfClass: NSClassFromString(@"IBStoryboardStructureViewController")] ){
        navigationOutlineViewController = [(IBStoryboardStructureViewController *)structureViewController documentOutlineViewController];
    } else if( [structureViewController isKindOfClass: NSClassFromString(@"IBHybridStructureViewController")] ){
        navigationOutlineViewController = [(IBHybridStructureViewController *)structureViewController outlineViewController];
    }
    
    if( navigationOutlineViewController ){
        IBOutlineViewController *outlineViewController = [navigationOutlineViewController outlineViewController];
        IBOutlineView *outlineView = [outlineViewController outlineView];

        // Find rows to highlite
        NSMutableSet *highlightedRows = [NSMutableSet set];

        for( NSObject *object in objects ){
            IBOutlineViewControllerItem *outlineViewControllerItem = [outlineViewController itemForMemberWrapper: [document memberWrapperForMember:object]];
            
            NSInteger row = [outlineView rowForItem:outlineViewControllerItem];
            if( row >= 0 ){
                [highlightedRows addObject: @(row)];
            }
        }

        [outlineView setHighlightedRows: highlightedRows];
    }
}


@end






//
//  RRAbstractDocumentEditor.m
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

#import "IBAbstractDocumentEditor.h"
#import "IBCanvasViewController.h"
#import "IBViewEditor.h"


@interface RRAbstractDocumentEditor : NSViewController <IBAbstractDocumentEditor>

@end


@implementation RRAbstractDocumentEditor


#pragma mark -
#pragma mark NSObject


+ (void)load {
    [NSClassFromString(@"IBAbstractDocumentEditor") importMethodsFromClass:[self class] exchangeImplementationsPrefix:"rr_"];
}


#pragma mark -
#pragma mark IBAbstractDocumentEditor


- (BOOL)rr_validateUserInterfaceItem:(NSMenuItem *)menuItem {
    if( [NSStringFromSelector(menuItem.action) isEqualToString:@"toggleColoringConstraints:"] ){
        [menuItem setState: (([self isColoringConstraints])?NSOnState:NSOffState)];
        return YES;
    }else{
        return [self rr_validateUserInterfaceItem:menuItem];
    }
}


#pragma mark -
#pragma mark RRAbstractDocumentEditor


- (void)toggleColoringConstraints:(NSMenuItem *)menuItem {
    [self setColoringConstraints: !self.isColoringConstraints];
}


- (BOOL)isColoringConstraints {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"RRConstraintsPlugin.InterfaceBuilderKit.DocumentEditorMenu.Canvas.ColoringConstraints"];
}


- (void)setColoringConstraints:(BOOL)coloringConstraints {
    [[NSUserDefaults standardUserDefaults] setBool:coloringConstraints
                                            forKey:@"RRConstraintsPlugin.InterfaceBuilderKit.DocumentEditorMenu.Canvas.ColoringConstraints"];

    [self.canvasViewController.activeEditors makeObjectsPerformSelector:@selector(updateConstraintVisibilityBasedUponSelection)];
}


@end

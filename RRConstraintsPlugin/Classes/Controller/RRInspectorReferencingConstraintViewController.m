//
//  RRInspectorReferencingConstraintViewController.m
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

#import "IBInspectorReferencingConstraintViewController.h"
#import "IBInspectorReferencingConstraintView.h"
#import "NSImage+RRFilters.h"
#import "IBLayoutConstraint.h"
#import <objc/runtime.h>


@interface RRInspectorReferencingConstraintViewController : NSViewController <IBInspectorReferencingConstraintViewController>

@end


@implementation RRInspectorReferencingConstraintViewController {

}


#pragma mark -
#pragma mark NSObject


+ (void)load {

    [NSClassFromString(@"IBInspectorReferencingConstraintViewController") importMethodsFromClass:[self class] exchangeImplementationsPrefix:"rr_"];

}


#pragma mark -
#pragma mark IBInspectorReferencingConstraintViewController


- (void)rr_updateImageView {
    [self rr_updateImageView];
    
    if( self.constraint.isPlaceholder ){
        NSImageView *imageView = [[self constraintView] imageView];
        [imageView setImage: [imageView.image grayscaleImage]];
    }
}


- (NSFont *)rr_leftHandLabelFont {
    NSFont *leftHandLabelFont = [self rr_leftHandLabelFont];

    if( self.constraint.secondItem && ![self.constraint.secondItem isEqual:self.relatedViewInConstraintRelationship] ){
        leftHandLabelFont = [NSFont fontWithName:leftHandLabelFont.fontName size:leftHandLabelFont.pointSize -2];
    }
    
    return leftHandLabelFont;
}


- (NSFont *)rr_rightHandLabelFont {
    NSFont *rightHandLabelFont = [self rr_rightHandLabelFont];

    if( self.constraint.secondItem && ![self.constraint.secondItem isEqual:self.relatedViewInConstraintRelationship] ){
        rightHandLabelFont = [NSFont fontWithName:rightHandLabelFont.fontName size:rightHandLabelFont.pointSize -2];
    }
    
    return rightHandLabelFont;
}


- (void)rr_updateMenuItems {
    [self rr_updateMenuItems];
    
    if( self.constraint.secondItem ){
        NSMenuItem *reverseMenuItem = [self rr_reverseMenuItem];
        NSArray *itemArray = self.constraintView.popUpButton.menu.itemArray;
        
        if( ![itemArray containsObject:reverseMenuItem] ){
            [self.constraintView.popUpButton.menu insertItem: reverseMenuItem
                                                     atIndex: [itemArray indexOfObject: self.deleteMenuItem] -1];
        }
    }
}


#pragma mark -
#pragma mark RRInspectorReferencingConstraintViewController


- (void)rr_reverseFirstAndSecondItem {
    [self.constraint reverseFirstAndSecondItem];
}


- (NSMenuItem *)rr_reverseMenuItem {
    NSMenuItem *reverseMenuItem = objc_getAssociatedObject(self, @selector(rr_reverseMenuItem));
    if( !reverseMenuItem ){
        reverseMenuItem = [[NSMenuItem alloc] initWithTitle:@"Reverse Items" action:@selector(rr_reverseFirstAndSecondItem) keyEquivalent:@"R"];
        [reverseMenuItem setTarget:self];
        objc_setAssociatedObject(self, @selector(rr_reverseMenuItem), reverseMenuItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return reverseMenuItem;
}


#pragma mark -
#pragma mark RRInspectorReferencingConstraintViewDelegate


- (void)constraintViewDidChangeConstantValue:(IBInspectorReferencingConstraintView *)view {

    IBLayoutConstant *layoutConstant = self.constraint.constant;
    double newValue = [self.constraintView.constantValueLabel doubleValue];
    
    if( newValue != layoutConstant.value ){
        Ivar documentIvar = class_getInstanceVariable([self class], "document");

        [self.constraint setIbInspectedConstant: [layoutConstant constantBySettingValueToValue: newValue]
                                       document: object_getIvar(self, documentIvar)
                frameDecideAfterSettingConstant: YES];
    }

}


@end

//
//  RRAutolayoutConstraintAdditionViewController.m
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

#import "IBAutolayoutConstraintAdditionViewController.h"
#import "IBAutolayoutConstraintAdditionTypeConfig.h"
#import "IBLayoutConstraint.h"
#import "IBLayoutConstant.h"
#import "IBDecimalLayoutConstraintMultiplier.h"
#import <objc/runtime.h>


@interface RRAutolayoutConstraintAdditionViewController : NSViewController <IBAutolayoutConstraintAdditionViewController>

@end


@implementation RRAutolayoutConstraintAdditionViewController


#pragma mark -
#pragma mark NSObject


+ (void)load {
    [NSClassFromString(@"IBAutolayoutConstraintAdditionViewController") importMethodsFromClass:[self class] exchangeImplementationsPrefix:"rr_"];
}


#pragma mark -
#pragma mark RRAutolayoutConstraintAdditionViewController


- (NSMutableDictionary *)typeConfigurationsByAlignmentType {
    Ivar typeConfigurationsByAlignmentTypeIvar = class_getInstanceVariable([self class], "_typeConfigurationsByAlignmentType");
    return object_getIvar(self, typeConfigurationsByAlignmentTypeIvar);
}


#pragma mark -
#pragma mark IBAutolayoutConstraintAdditionViewController


- (void)rr__addEdgeOrCenterAlignmentTypeConfigurationsToSet:(NSMutableSet *)typeConfigurations {
    [self rr__addEdgeOrCenterAlignmentTypeConfigurationsToSet:typeConfigurations];

    
    // affectedItems
    IBAutolayoutConstraintAdditionTypeConfig *leadingEdgesAutolayoutConstraintAdditionTypeConfig = [[self typeConfigurationsByAlignmentType] objectForKey:@1];
    NSSet *leadingEdgesConstraints = leadingEdgesAutolayoutConstraintAdditionTypeConfig.constraints;
    
    NSObject<IBAutolayoutItem> *containingView;
    NSMutableOrderedSet *affectedItems = [NSMutableOrderedSet orderedSet];
    
    for( IBLayoutConstraint *layoutConstraint in leadingEdgesConstraints ){
        [affectedItems addObject: layoutConstraint.firstItem];
        [affectedItems addObject: layoutConstraint.secondItem];

        containingView = layoutConstraint.containingView;
    }
    
    
    // Can distribute only 2 or more views
    if( affectedItems.count < 2 ) return;

    
    // Check for same size
    CGSize commonSize = [affectedItems[0] frame].size;
    for( NSView *view in affectedItems ){
        if( commonSize.width && view.frame.size.width != commonSize.width ) {
            commonSize.width = 0.0f;
        }
        if( commonSize.height && view.frame.size.height != commonSize.height ) {
            commonSize.height = 0.0f;
        }
    }


    // Distribute - Horizontally (if widths are same)
    if( commonSize.width ){
        // Sort on X axis
        [affectedItems sortUsingComparator:^NSComparisonResult(NSView *obj1, NSView *obj2) {
            if ( obj1.frame.origin.x > obj2.frame.origin.x ){
                return NSOrderedDescending;
            }
            if ( obj1.frame.origin.x < obj2.frame.origin.x ){
                return NSOrderedAscending;
            }
            return NSOrderedSame;
        }];
        
        // New constraints
        NSMutableSet *constraints = [NSMutableSet set];
        
        for ( NSUInteger i = 0; i < affectedItems.count; i++ ) {
            NSView *view = affectedItems[i];

            CGFloat multiplier = (i *2.0f    +2.0f) /((float)affectedItems.count +1.0f);
            CGFloat constant   = (multiplier -1.0f) *commonSize.width /2.0f;

            IBLayoutConstraint *layoutConstraint = [[NSClassFromString(@"IBLayoutConstraint") alloc] initWithFirstItem: view
                                                                                                        firstAttribute: NSLayoutAttributeCenterX
                                                                                                              relation: NSLayoutRelationEqual
                                                                                                            secondItem: containingView
                                                                                                       secondAttribute: NSLayoutAttributeCenterX
                                                                                                            multiplier: [[NSClassFromString(@"IBDecimalLayoutConstraintMultiplier") alloc] initWithValue:multiplier stringValue:[NSString stringWithFormat:@"%f", multiplier]]
                                                                                                              constant: [[NSClassFromString(@"IBLayoutConstant") alloc] initWithValue:constant]
                                                                                                              priority: NSLayoutPriorityRequired];
            [layoutConstraint setContainingView:containingView];
            
            [constraints addObject:layoutConstraint];
        }

        IBAutolayoutConstraintAdditionTypeConfig *autolayoutConstraintAdditionTypeConfig = [self _typeConfigurationWithField:nil checkBox:nil startingConstant:nil andConstraints: constraints];
        [autolayoutConstraintAdditionTypeConfig setEnabled:YES];
        
        [[self typeConfigurationsByAlignmentType] setObject:autolayoutConstraintAdditionTypeConfig forKey:@101];
        [typeConfigurations addObject:autolayoutConstraintAdditionTypeConfig];
    }

    
    // Distribute - Vertically (if heights are same)
    if( commonSize.height ){
        // Sort on Y axis
        [affectedItems sortUsingComparator:^NSComparisonResult(NSView *obj1, NSView *obj2) {
            if ( obj1.frame.origin.y > obj2.frame.origin.y ){
                return NSOrderedAscending;
            }
            if ( obj1.frame.origin.y < obj2.frame.origin.y ){
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }];
        
        
        // New constraints
        NSMutableSet *constraints = [NSMutableSet set];
        
        for ( NSUInteger i = 0; i < affectedItems.count; i++ ) {
            NSView *view = affectedItems[i];
            
            CGFloat multiplier = (i *2.0f    +2.0f) /((float)affectedItems.count +1.0f);
            CGFloat constant   = (multiplier -1.0f) *commonSize.height /2.0f;
            
            IBLayoutConstraint *layoutConstraint = [[NSClassFromString(@"IBLayoutConstraint") alloc] initWithFirstItem: view
                                                                                                        firstAttribute: NSLayoutAttributeCenterY
                                                                                                              relation: NSLayoutRelationEqual
                                                                                                            secondItem: containingView
                                                                                                       secondAttribute: NSLayoutAttributeCenterY
                                                                                                            multiplier: [[NSClassFromString(@"IBDecimalLayoutConstraintMultiplier") alloc] initWithValue:multiplier stringValue:[NSString stringWithFormat:@"%f", multiplier]]
                                                                                                              constant: [[NSClassFromString(@"IBLayoutConstant") alloc] initWithValue:constant]
                                                                                                              priority: NSLayoutPriorityRequired];
            [layoutConstraint setContainingView:containingView];
            
            [constraints addObject:layoutConstraint];
        }
        
        IBAutolayoutConstraintAdditionTypeConfig *autolayoutConstraintAdditionTypeConfig = [self _typeConfigurationWithField:nil checkBox:nil startingConstant:nil andConstraints: constraints];
        [autolayoutConstraintAdditionTypeConfig setEnabled:YES];
        
        [[self typeConfigurationsByAlignmentType] setObject:autolayoutConstraintAdditionTypeConfig forKey:@102];
        [typeConfigurations addObject:autolayoutConstraintAdditionTypeConfig];
    }
    
}


- (void)rr_setAlignPopUpMenu:(NSMenu *)alignPopUpMenu {
    
    // separator
    [alignPopUpMenu addItem: [NSMenuItem separatorItem]];
    
    // Distribute - Horizontally
    NSMenuItem *horizontalMenuItem = [[NSMenuItem alloc] init];
    [horizontalMenuItem setTitle:@"Distribute Horizontally"];
    [horizontalMenuItem setTag: 101];
    [alignPopUpMenu addItem: horizontalMenuItem];
    
    // Distribute - Vertical
    NSMenuItem *verticalMenuItem = [[NSMenuItem alloc] init];
    [verticalMenuItem setTitle:@"Distribute Vertically"];
    [verticalMenuItem setTag: 102];
    [alignPopUpMenu addItem: verticalMenuItem];
    
    [self rr_setAlignPopUpMenu:alignPopUpMenu];
    
}


- (BOOL)rr_validateMenuItem:(NSMenuItem *)menuItem {
    
    if( menuItem.tag >= 100 ){
        IBAutolayoutConstraintAdditionTypeConfig *autolayoutConstraintAdditionTypeConfig = [self _typeConfigurationForAlignmentType:menuItem.tag];
        return [autolayoutConstraintAdditionTypeConfig enabled];
    }else{
        return [self rr_validateMenuItem:menuItem];
    }
    
}


@end

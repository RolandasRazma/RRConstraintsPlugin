//
//  RRSubviewEmbeddingPolicy.m
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

#import "IBSubviewEmbeddingPolicy.h"
#import "IBUIView.h"
#import "IBLayoutConstraint.h"


@interface RRSubviewEmbeddingPolicy : NSObject <IBSubviewEmbeddingPolicy>

@end


@implementation RRSubviewEmbeddingPolicy


#pragma mark -
#pragma mark NSObject


+ (void)load {
    [NSClassFromString(@"IBSubviewEmbeddingPolicy") importMethodsFromClass:[self class] exchangeImplementationsPrefix:"rr_"];
}


#pragma mark -
#pragma mark IBSubviewEmbeddingPolicy


- (IBNSCustomView *)rr_embedObjects:(NSArray *)objects fromDocument:(IBXIBDocument *)document context:(NSMutableDictionary *)context {

    // Store constraints
    NSMapTable *constraints = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableStrongMemory];
    for( IBUIView *view in objects ){
        [constraints setObject:view.ibInstalledReferencingConstraints forKey:view];
    }
    
    IBNSCustomView *newParentView = [self rr_embedObjects:objects fromDocument:document context:context];
    
    // Check for lost constraints
    for( IBUIView *view in objects ){
        NSArray *oldConstraints = [constraints objectForKey:view];
        NSArray *newConstraints = view.ibInstalledReferencingConstraints;

        for( IBLayoutConstraint *layoutConstraint in oldConstraints ){
            if( [newConstraints containsObject:layoutConstraint] ) continue;

            BOOL wasFirstItemMoved = [layoutConstraint.firstItem isEqualTo:view];
            if( wasFirstItemMoved ){

                // Did both items moved?
                if( [layoutConstraint.secondItem.superview isEqual:layoutConstraint.firstItem.superview] ){
                    [layoutConstraint setContainingView:newParentView];
                }
                // If only 1
                else{
                    if( [layoutConstraint.secondItem.superview isEqual:newParentView.superview] ){
                        [layoutConstraint setFirstItem: newParentView];
                    }else{
                        [layoutConstraint setSecondItem: newParentView];
                    }
                }
                
            }else{

                // Did both items moved?
                if( [layoutConstraint.secondItem.superview isEqual:layoutConstraint.firstItem.superview] ){
                    [layoutConstraint setContainingView:newParentView];
                }
                // If only 1
                else{
                    if( [layoutConstraint.firstItem.superview isEqual:newParentView.superview] ){
                        [layoutConstraint setSecondItem: newParentView];
                    }else{
                        [layoutConstraint setFirstItem: newParentView];
                    }
                }
                
            }
            
            [layoutConstraint.containingView ibAddCandidateConstraints:[NSMutableSet setWithObject:layoutConstraint] offInEmptyConfigurationAndOnInConfiguration:nil];
        }
    }
    
    return newParentView;
}


@end

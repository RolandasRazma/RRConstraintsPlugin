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
    NSMutableSet *newParentViewConstraints = [NSMutableSet set];
    
    // Check for lost constraints
    for( IBUIView *view in objects ){
        NSArray *oldConstraints = [constraints objectForKey:view];
        NSArray *newConstraints = view.ibInstalledReferencingConstraints;

        for( IBLayoutConstraint *layoutConstraint in oldConstraints ){
            if( [newConstraints containsObject:layoutConstraint] ) continue;

            if( [layoutConstraint.firstItem isEqualTo:view] ){
                [layoutConstraint setSecondItem: newParentView];
            }else{
                [layoutConstraint setFirstItem: newParentView];
            }
            
            [layoutConstraint setContainingView:newParentView];
            
            [newParentViewConstraints addObject: layoutConstraint];
        }
    }
    
    // Add removed constraints
    if( newParentViewConstraints.count ){
        [newParentView ibAddCandidateConstraints:newParentViewConstraints offInEmptyConfigurationAndOnInConfiguration:nil];
    }
    
    return newParentView;
}


@end

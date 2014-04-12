//
//  RRInspectorReferencingConstraintView.m
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

#import "IBInspectorReferencingConstraintView.h"
#import "RRInspectorReferencingConstraintViewDelegate.h"


@interface RRInspectorReferencingConstraintView : NSView <NSTextFieldDelegate, IBInspectorReferencingConstraintView>

@property(nonatomic) __weak id <RRInspectorReferencingConstraintViewDelegate> delegate;

@end


@implementation RRInspectorReferencingConstraintView


#pragma mark -
#pragma mark NSObject


+ (void)load {
    
    [NSClassFromString(@"IBInspectorReferencingConstraintView") importMethodsFromClass:[self class] exchangeImplementationsPrefix:"rr_"];
    
}


#pragma mark -
#pragma mark NSResponder


- (void)mouseUp:(NSEvent *)event {
    [super mouseUp:event];
    
    if( event.clickCount == 2 ){
        [self.delegate constraintViewDidDoubleClick: (IBInspectorReferencingConstraintView *)self];
    }
}


#pragma mark -
#pragma mark NSView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.constantValueLabel setEditable:YES];
    [self.constantValueLabel setTarget:self];
    [self.constantValueLabel setAction:@selector(updateConstantValue)];

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [numberFormatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    [numberFormatter setUsesGroupingSeparator:NO];
    
    [self.constantValueLabel setFormatter: numberFormatter];

}


#pragma mark -
#pragma mark RRInspectorReferencingConstraintView


- (void)updateConstantValue {
    
    // this is hack, but have no idea how to resign responder in fullscreen app
    [self.constantValueLabel.window makeFirstResponder: [(id)self.delegate view]];

    [self.delegate constraintViewDidChangeConstantValue: (IBInspectorReferencingConstraintView *)self];
    
}


@end
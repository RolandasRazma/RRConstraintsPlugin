//
//  IBLayoutConstraint.h
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


@class IBDocument, IBLayoutConstraintMultiplier, IBLayoutConstant;
@protocol IBAutolayoutItem;


@protocol IBLayoutConstraint <NSObject>
@optional

@property(retain, nonatomic) IBLayoutConstant *constant;
@property(nonatomic, getter=isPlaceholder) BOOL placeholder;
@property(nonatomic) NSObject<IBAutolayoutItem> *firstItem;
@property(nonatomic) NSObject<IBAutolayoutItem> *secondItem;
@property(nonatomic) NSObject<IBAutolayoutItem> *containingView;

- (instancetype)initWithFirstItem:(id)view1 firstAttribute:(NSLayoutAttribute)attribute1 relation:(NSLayoutRelation)relation secondItem:(id)view2 secondAttribute:(NSLayoutAttribute)secondAttribute multiplier:(IBLayoutConstraintMultiplier *)multiplier constant:(IBLayoutConstant *)constant priority:(double)priority;

- (void)reverseFirstAndSecondItem;
- (void)setIbInspectedConstant:(IBLayoutConstant *)layoutConstant document:(IBDocument *)document frameDecideAfterSettingConstant:(BOOL)decide;

@end


@interface IBLayoutConstraint : NSObject <IBLayoutConstraint>

@end
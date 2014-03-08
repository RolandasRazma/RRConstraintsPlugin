//
//  NSObject+RRDumpAdditions.m
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
//
//  http://blog.bignerdranch.com/3218-inside-the-bracket-part-5-runtime-api/
//

#import "NSObject+RRDumpAdditions.h"
#import <objc/runtime.h>


@implementation NSObject (RRDumpAdditions)


+ (void)dumpInstanceMethodSignatureForSelector:(SEL)selector {
    
    NSMutableString *info = [NSMutableString string];
    NSArray *components = [NSStringFromSelector(selector) componentsSeparatedByString:@":"];
    
    NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:selector];
    
    [info appendFormat:@"-(%s)%@", [methodSignature methodReturnType], [components objectAtIndex:0]];
    
    for( NSUInteger i=2; i<methodSignature.numberOfArguments; i++ ){
        [info appendFormat:@": %s", [methodSignature getArgumentTypeAtIndex:i]];
        
        if( i < methodSignature.numberOfArguments ){
            [info appendFormat:@" %@", [components objectAtIndex:i-1]];
        }
    }
    
    NSLog(@"%@", info);
    
}


+ (void)dumpAllClasses {
    int numberOfClasses = objc_getClassList(NULL, 0);
    Class *classList = (Class *)malloc(numberOfClasses *sizeof(Class));
    numberOfClasses = objc_getClassList(classList, numberOfClasses);
    
    NSMutableArray *classListArray = [NSMutableArray arrayWithCapacity:numberOfClasses];
    
    for (int idx = 0; idx < numberOfClasses; idx++) {
        Class class = classList[idx];
        [classListArray addObject: [NSString stringWithFormat:@"%@ (%@)", NSStringFromClass(class), NSStringFromClass(class_getSuperclass(class))]];
    }
    free(classList);
    
    NSLog(@"classes: %@", classListArray);
}


- (void)dumpInfo {
    Class clazz = [self class];
    u_int count;
    
    // Ivars
    Ivar *ivars = class_copyIvarList(clazz, &count);
    NSMutableArray* ivarArray = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; i++){
        const char *ivarName = ivar_getName(ivars[i]);
        [ivarArray addObject:[NSString  stringWithCString:ivarName encoding:NSUTF8StringEncoding]];
    }
    free(ivars);
    
    // Properties
    objc_property_t *properties = class_copyPropertyList(clazz, &count);
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    for ( NSUInteger i = 0; i < count; i++ ){
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    
    // Methods
    Method *methods = class_copyMethodList(clazz, &count);
    NSMutableArray *methodArray = [NSMutableArray arrayWithCapacity:count];
    for ( NSUInteger i = 0; i < count ; i++ ) {
        SEL selector = method_getName(methods[i]);
        const char* methodName = sel_getName(selector);
        [methodArray addObject:[NSString  stringWithCString:methodName encoding:NSUTF8StringEncoding]];
    }
    free(methods);
    
    NSMutableDictionary *classDump = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      ivarArray,       @"ivars",
                                      propertyArray,   @"properties",
                                      methodArray,     @"methods",
                                      nil];
    
    NSLog(@"%@ %@", clazz, classDump);
}


@end

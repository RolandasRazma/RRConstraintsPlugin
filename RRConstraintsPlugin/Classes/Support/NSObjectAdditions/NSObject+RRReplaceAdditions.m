//
//  NSObject+RRReplaceAdditions.m
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

#import "NSObject+RRReplaceAdditions.h"
#import <objc/runtime.h>


@implementation NSObject (RRReplaceAdditions)


+ (void)importMethodsFromClass:(Class)otherClass exchangeImplementationsPrefix:(const char *)prefix {
    
    Class selfClass = [self class];
    
    u_int count;
    
    // Instance methods
    Method *methods = class_copyMethodList(otherClass, &count);
    for ( NSUInteger i = 0; i < count ; i++ ) {
        SEL selector = method_getName(methods[i]);

        Method newMethod = class_getInstanceMethod(otherClass, selector);
        if( class_addMethod(selfClass, selector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)) ){
            
            const char *methodName = sel_getName(selector);
            if( strstr(methodName, prefix) != NULL ) {

                char *realName = strndup(methodName +strlen(prefix), strlen(methodName) -strlen(prefix));
                SEL originalSelector = sel_registerName( realName );
                free(realName);
                
                if( [self instancesRespondToSelector:originalSelector] ){
                    [self replaceInstanceSelector:originalSelector withSelector:selector];
                }
            }
        }
    }
    free(methods);
    
    // Class methods
    Class selfMetaClass = objc_getMetaClass(class_getName(selfClass));
    Class otherMetaClass= objc_getMetaClass(class_getName(otherClass));
    
    methods = class_copyMethodList(object_getClass(otherClass), &count);
    for ( NSUInteger i = 0; i < count ; i++ ) {
        SEL selector = method_getName(methods[i]);
        
        // skip +[NSObject load]
        if( selector == @selector(load) ) continue;

        Method newMethod = class_getClassMethod(otherMetaClass, selector);
        if( class_addMethod(selfMetaClass, selector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)) ){
            
            const char *methodName = sel_getName(selector);
            if( strstr(methodName, prefix) != NULL ) {
                
                char *realName = strndup(methodName +strlen(prefix), strlen(methodName) -strlen(prefix));
                SEL originalSelector = sel_registerName( realName );
                free(realName);
                
                if( [self respondsToSelector:originalSelector] ){
                    [self replaceClassSelector:originalSelector withSelector:selector];
                }
            }
        }
    }
    free(methods);
    
}


+ (void)replaceClassSelector:(SEL)originalSelector withSelector:(SEL)newSelector {

    Class class = objc_getMetaClass(class_getName([self class]));
    method_exchangeImplementations(class_getClassMethod(class, originalSelector), class_getClassMethod(class, newSelector));

}


+ (void)replaceInstanceSelector:(SEL)originalSelector withSelector:(SEL)newSelector {

    Class class = [self class];
    method_exchangeImplementations(class_getInstanceMethod(class, originalSelector), class_getInstanceMethod(class, newSelector));
    
}


@end

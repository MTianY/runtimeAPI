//
//  TYPerson.h
//  runtimeAPIDemo
//
//  Created by 马天野 on 2018/10/8.
//  Copyright © 2018 Maty. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYPerson : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;
- (void)run;

@end

NS_ASSUME_NONNULL_END

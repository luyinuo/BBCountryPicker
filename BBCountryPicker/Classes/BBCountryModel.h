//
//  BBCountryModel.h
//  
//
//  Created by kevinlu on 2018/5/30.
//  Copyright © 2018年 BOBBY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBCountryModel : NSObject
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *Number;
+ (instancetype) modelWithDic:(NSMutableDictionary *)dic;
@end

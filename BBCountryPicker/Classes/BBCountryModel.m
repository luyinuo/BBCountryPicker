//
//  BBCountryModel.m
//  Bobby
//
//  Created by kevinlu on 2018/5/30.
//  Copyright © 2018年 BOBBY. All rights reserved.
//

#import "BBCountryModel.h"

@implementation BBCountryModel
+ (instancetype) modelWithDic:(NSMutableDictionary *)dic {
    BBCountryModel *countryModel = [BBCountryModel new];
    countryModel.Name = dic[@"Name"];
    countryModel.Number = dic[@"Number"];
    return countryModel;
}
@end

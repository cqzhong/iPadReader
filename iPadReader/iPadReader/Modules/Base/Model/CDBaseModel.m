//
//  CDBaseModel.m
//  CDProgramme
//
//  Created by 庆中 on 2018/7/2.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDBaseModel.h"

@implementation CDBaseModel

- (BOOL)isValid {
    
    return true;
}
- (NSError *)validError
{
    return nil;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
};
- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    if (!dic) {
        return dic;
    }
    
    NSDictionary <NSString *,id>*nonnullDict = [self nonnullDefaultValueProperties];
    
    if (!nonnullDict) {
        return dic;
    }
    
    NSMutableDictionary *orangleDict = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    for (NSString *key in nonnullDict.allKeys) {
        
        if ([orangleDict objectForKey:key] == nil) {
            
            [orangleDict setObject:[nonnullDict objectForKey:key] forKey:key];
        }
    }
    
    return orangleDict;
}
- (NSString *)description {
    
    return [self yy_modelDescription];
}
- (NSString *)debugDescription {
    
    return [self yy_modelDescription];
}
- (nullable NSDictionary <NSString *,id>*)nonnullDefaultValueProperties {
    
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [self yy_modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init]; return [self yy_modelInitWithCoder:aDecoder];
}
- (id)copyWithZone:(NSZone *)zone {
    
    return [self yy_modelCopy];
}
- (NSUInteger)hash {
    
    return [self yy_modelHash];
}
- (BOOL)isEqual:(id)object {
    
    return [self yy_modelIsEqual:object];
}

//+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
//    return @{@"data":[ListDataModel class]};
//}
//+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
//    return @{@"children_score" : @"children_content_score"};
//}


@end

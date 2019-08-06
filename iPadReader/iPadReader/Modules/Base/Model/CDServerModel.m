//
//  CDServerModel.m
//  CDProgramme
//
//  Created by 庆中 on 2018/7/2.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDServerModel.h"

@implementation CDServerModel

//+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
//
//    return @{
//             @"code" : @[@"status",@"code"],
//             @"msg" : @[@"msg",@"status_desc",@"message"],
//             @"remark" : @"status_desc_remarks",
//             @"content" : @[@"data",@"content"],
//             };
//}

- (NSString *)msg {
    if (_msg.length ==0 ) {
        _msg = @"网络错误，请稍后重试！";
    }
    return _msg;
}
- (id)data {
    if (!_data && [self isValid]) {
        _data = self.msg;
    }
    return _data;
}
- (BOOL)isValid {
    
    if (self.code == CDAPPErrorStatusSuccess || self.code == 0) {
        return true;
    }
    return false;
}
- (NSError *)validError {
    
    if ([self isValid]) {
        return nil;
    }
    
    return [NSError errorWithDomain:@"AppError" code:self.code userInfo:@{NSLocalizedFailureReasonErrorKey : self.remark?:@"未知原因",NSLocalizedDescriptionKey : self.msg ? : @"网络错误，请稍后重试！", @"NSErrorAPPErrorKey" : @"NSErrorAPPErrorValue"}];
}


@end

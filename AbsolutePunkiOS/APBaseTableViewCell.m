//
//  APBaseTableViewCell.m
//  AbsolutePunkiOS
//
//  Created by RB de Guzman on 9/28/15.
//  Copyright (c) 2015 RB de Guzman. All rights reserved.
//

#import "APBaseTableViewCell.h"

@implementation APBaseTableViewCell
+(instancetype)loadNib {
    UINib *nib = [UINib nibWithNibName:[self reuseIdentifier] bundle:[NSBundle mainBundle]];
    NSArray *nibArray = [nib instantiateWithOwner:nil options:nil];
    return nibArray[0];
}

+(NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
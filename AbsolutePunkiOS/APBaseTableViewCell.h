//
//  APBaseTableViewCell.h
//  AbsolutePunkiOS
//
//  Created by RB de Guzman on 9/28/15.
//  Copyright (c) 2015 RB de Guzman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APBaseTableViewCell : UITableViewCell
+(instancetype)loadNib;
+(NSString *)reuseIdentifier;
@end
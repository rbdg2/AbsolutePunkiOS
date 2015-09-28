//
//  APItemTableViewCell.h
//  AbsolutePunkiOS
//
//  Created by RB de Guzman on 9/28/15.
//  Copyright (c) 2015 RB de Guzman. All rights reserved.
//

#import "APBaseTableViewCell.h"

@interface APItemTableViewCell : APBaseTableViewCell
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subtitleLabel;
@end
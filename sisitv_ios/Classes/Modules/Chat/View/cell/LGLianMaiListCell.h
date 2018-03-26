//
//  LGLianMaiListCell.h
//  sisitv_ios
//
//  Created by Ming on 2018/1/19.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGButtont.h"

@interface LGLianMaiListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet  LGButtont*join;
@property (weak, nonatomic) IBOutlet LGButtont *noJoin;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

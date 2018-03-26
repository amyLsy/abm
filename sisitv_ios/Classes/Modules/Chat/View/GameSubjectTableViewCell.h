//
//  GameSubjectTableViewCell.h
//  sisitv_ios
//
//  Created by 悟不透。 on 2017/10/8.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameSubjectTableViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *subjectLab;
@property (nonatomic,weak) IBOutlet UIImageView *subjectCheckImage;
@property(nonatomic, strong) NSString *answerId;

@end

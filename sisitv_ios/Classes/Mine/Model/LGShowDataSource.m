//
//  LGShowDataSource.m
//  sisitv_ios
//
//  Created by Ming on 2017/12/28.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "LGShowDataSource.h"

@implementation LGShowDataSource
-(Class)tableView:(UITableView *)tableView cellClassForSection:(NSInteger)section{
    
    return [LGShowListCell class];
}
@end

//
//  MainDataSource.m
//  xiuPai
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年 JLXX--YZG. All rights reserved.
//

#import "MainDataSource.h"
#import "LGMediaListModel.h"
#import "HSYTopicCell.h"
@implementation MainDataSource

-(Class)tableView:(UITableView *)tableView cellClassForItem:(id)item{
    //BannerTableViewCell的item是一个存放着banner对象的数组
    if ([item isKindOfClass:[NSArray class]]) {
        return [BannerTableViewCell class];
    }else if([item isKindOfClass:[LGMediaListModel class]]){
        return [HSYTopicCell class];
    }else{
        
         return [MainTableViewCell class];
    }
}



@end

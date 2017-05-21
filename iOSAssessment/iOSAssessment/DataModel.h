//
//  DataModel.h
//  iOSAssessment
//
//  Created by helloworld on 17/5/20.
//  Copyright © 2017年 topkid. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MyTableViewCell.h"

@interface DataModel : NSObject

@property (nonatomic, strong)NSMutableArray *VideoURLArray;
@property (nonatomic, strong)NSMutableArray *AuthorImageURLArray;
@property (nonatomic, strong)NSMutableArray *AuthorNameArray;
@property (nonatomic, strong)NSMutableArray *TimeArray;
@property (nonatomic, strong)NSMutableArray *VideoTitleArray;

@property (nonatomic, strong)MyTableViewCell *MyCell;

- (void)HTTPSRequest: (NSString*) URL;

@end

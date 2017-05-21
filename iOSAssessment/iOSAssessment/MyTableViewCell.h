//
//  MyTableViewCell.h
//  iOSAssessment
//
//  Created by helloworld on 17/5/20.
//  Copyright © 2017年 topkid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MyTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *AuthorImage;
@property (nonatomic, strong)UILabel *AuthorName;
@property (nonatomic, strong)UILabel *TimeLabel;
@property (nonatomic, strong)UILabel *VideoTitle;
@property (nonatomic, strong)NSMutableArray *VideoURLArray;
@property (nonatomic, strong)UIButton *PlayButton;
@property (nonatomic, strong)UIButton *DownloadButton;
@property (nonatomic, strong)UILabel *HUDLabel;

@property (nonatomic,strong) AVPlayer *player;//播放器对象
@property (nonatomic, strong)AVPlayerItem *playerItem;


@end

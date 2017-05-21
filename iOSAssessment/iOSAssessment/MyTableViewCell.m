//
//  MyTableViewCell.m
//  iOSAssessment
//
//  Created by helloworld on 17/5/20.
//  Copyright © 2017年 topkid. All rights reserved.
//

#import "MyTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

@interface MyTableViewCell ()

@property (strong, nonatomic) UIView *container; //播放器容器
@property (strong, nonatomic) UIButton *playOrPauseButton; //播放/暂停按钮
@property (strong, nonatomic) UIProgressView *progress;//播放进度

@end

@implementation MyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubCell];
    }
    
    return self;
}


- (void)initSubCell {
    _AuthorImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [self.contentView addSubview:_AuthorImage];
    
    
    _AuthorName = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 300, 20)];
    [self.contentView addSubview:_AuthorName];
    
    _TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 300, 20)];
    [self.contentView addSubview:_TimeLabel];
    
    _VideoTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 355, 80)];
    [_VideoTitle setFont:[UIFont systemFontOfSize:15.0]];
    [self.contentView addSubview:_VideoTitle];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 150, 375, 250)];
    [self.contentView addSubview:self.container];
    
    
    self.PlayButton = [[UIButton alloc] initWithFrame:CGRectMake(187.5 - 25, 275 - 25, 50, 50)];
    [self.PlayButton setImage:[UIImage imageNamed:@"player_start_iphone_window@3x.png"] forState:UIControlStateNormal];
    [self.PlayButton addTarget:self action:@selector(clickPlayButton) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:self.PlayButton];
    
    
    self.playOrPauseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 400, 50, 50)];
    
    
    if(self.player.rate==0){ //说明时暂停
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"play46.png"] forState:UIControlStateNormal];
        [self.player play];
    }else if(self.player.rate==1){//正在播放
        [self.player pause];
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"play46.png"] forState:UIControlStateNormal];
    }

    [self.contentView addSubview:self.playOrPauseButton];
    [self.playOrPauseButton addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchDown];
    
    self.HUDLabel = [[UILabel alloc] initWithFrame:CGRectMake(375/2.0 - 150, 440, 300, 50)];
    self.HUDLabel.text = @"由于版权原因，无法下载";
    self.HUDLabel.alpha = 0;
    self.HUDLabel.textAlignment = NSTextAlignmentCenter;
    self.HUDLabel.textColor = [UIColor grayColor];
    [self.HUDLabel setFont:[UIFont systemFontOfSize:15.0]];
    [self.contentView addSubview:self.HUDLabel];
    
    
    self.progress = [[UIProgressView alloc] initWithFrame:CGRectMake(50, 400, 325 - 40, 50)];
    
    self.progress.progressViewStyle = UIProgressViewStyleDefault;
    //轨道颜色
    self.progress.trackTintColor = [UIColor grayColor];
    //进度颜色
    self.progress.progressTintColor = [UIColor blueColor];
    //进度初始值
    self.progress.progress = 0.0;
    
    [self.contentView addSubview:self.progress];
    
    
    self.DownloadButton = [[UIButton alloc] initWithFrame:CGRectMake(375 - 40, 400, 40, 50)];
    [self.DownloadButton setImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
    
    
    [self.DownloadButton addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:self.DownloadButton];
    
    [self setupUI];
    [self.player pause];
    
    
}


- (void)download {
    self.HUDLabel.alpha = 1;
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0f];
}

- (void) delayMethod {
    self.HUDLabel.alpha = 0;
}

- (void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName tag:(NSInteger)aTag {
    ;
}


- (void)clickPlayButton {
    [self.player play];
    self.PlayButton.alpha = 0;
    [self.playOrPauseButton setImage:[UIImage imageNamed:@"pause17.png"] forState:UIControlStateNormal];
}


-(void)dealloc{
    [self removeObserverFromPlayerItem:self.player.currentItem];
    [self removeNotification];
}


-(void)setupUI{
    //创建播放器层
    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    
    playerLayer.frame = CGRectMake(0, 0, 375, 250);
    playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;//视频填充模式
    [self.container.layer addSublayer:playerLayer];
}



-(AVPlayer *)player{
    if (!_player) {
        self.playerItem=[self getPlayItem:0];
        _player=[AVPlayer playerWithPlayerItem:_playerItem];
        [self addProgressObserver];
        [self addObserverToPlayerItem:_playerItem];
    }
    return _player;
}


-(AVPlayerItem *)getPlayItem:(int)videoIndex{
    NSString *urlStr;
    urlStr = [NSString stringWithFormat:@"https://mvideo.spriteapp.cn/video/2017/0519/692ab34a-3c44-11e7-8fdf-90b11c479401_wpc.mp4"];
   
    //    urlStr =[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:url];
    return playerItem;
}



-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成.");
}



-(void)addProgressObserver{
    AVPlayerItem *playerItem=self.player.currentItem;
    UIProgressView *progress=self.progress;
    //这里设置每秒执行一次
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current=CMTimeGetSeconds(time);
        float total=CMTimeGetSeconds([playerItem duration]);
        NSLog(@"当前已经播放%.2fs.",current);
        if (current) {
            [progress setProgress:(current/total) animated:YES];
        }
    }];
}



-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem=object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
//            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
//        NSLog(@"共缓冲：%.2f",totalBuffer);
        //
    }
}


- (void)playClick {
    //    AVPlayerItemDidPlayToEndTimeNotification
    //AVPlayerItem *playerItem= self.player.currentItem;
    if(self.player.rate==0){ //说明时暂停
        self.PlayButton.alpha = 0;
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"pause17.png"] forState:UIControlStateNormal];
        [self.player play];
    }else if(self.player.rate==1){//正在播放
        self.PlayButton.alpha = 1;
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"play46.png"] forState:UIControlStateNormal];
        [self.player pause];
        
    }
}


@end

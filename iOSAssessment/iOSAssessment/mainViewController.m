//
//  mainViewController.m
//  iOSAssessment
//
//  Created by helloworld on 17/5/20.
//  Copyright © 2017年 topkid. All rights reserved.
//

#import "mainViewController.h"
#import "MyTableViewCell.h"
#import "DataModel.h"

@interface mainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) DataModel *dataModel;

@property (nonatomic, strong) MyTableViewCell *MyCell;

@end

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataModel = [[DataModel alloc] init];
    self.MyCell = [[MyTableViewCell alloc] init];
    
    [self.dataModel HTTPSRequest:@"https://route.showapi.com/255-1?showapi_appid=38521&showapi_sign=73b8ecf62c3948bfa7dafa358eccbd5d&type=41"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"reloadTableViewNotification" object:self.dataModel];
    

    [self.view addSubview:self.tableView];
}


- (void)reloadTableView {
    [self.tableView reloadData];
    NSLog(@"reload tableview");
    
}


- (UITableView *)tableView {
    if (!_tableView){
        self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataModel.AuthorImageURLArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 500;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    if (!cell) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    
    //头像
    if(self.dataModel.AuthorImageURLArray == nil) {
        cell.AuthorImage.image = [UIImage imageNamed:@"back@2x"];
    }
    else if(indexPath.row < [self.dataModel.AuthorImageURLArray count] && self.dataModel.AuthorImageURLArray[indexPath.row] != nil){
        cell.AuthorImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:_dataModel.AuthorImageURLArray[indexPath.row]]];
    }
    
    
    //名字
    if(self.dataModel.AuthorNameArray == nil) {
        cell.AuthorName.text = @" ";
    }
    else if(indexPath.row < [self.dataModel.AuthorNameArray count] && self.dataModel.AuthorNameArray[indexPath.row] != nil){
        cell.AuthorName.text = _dataModel.AuthorNameArray[indexPath.row];
    }
    
    
    //时间
    if(self.dataModel.TimeArray == nil) {
        cell.TimeLabel.text = @" ";
    }
    else if(indexPath.row < [self.dataModel.TimeArray count] && self.dataModel.TimeArray[indexPath.row] != nil){
        cell.TimeLabel.text = _dataModel.TimeArray[indexPath.row];
    }
    
    
    //描述  显示不了
    if(self.dataModel.VideoTitleArray == nil) {
        cell.VideoTitle.text = @" ";
    }
    else if(indexPath.row < [self.dataModel.VideoTitleArray count] && self.dataModel.VideoTitleArray[indexPath.row] != nil){
        NSString *tempStr = self.dataModel.VideoTitleArray[indexPath.row];
        
        tempStr = [tempStr substringFromIndex:11];
        cell.VideoTitle.text = tempStr;
    }
 
    
    //视频
    if(self.dataModel.VideoURLArray == nil) {
        ;
    }
    else if(indexPath.row < [self.dataModel.VideoURLArray count] && self.dataModel.VideoURLArray[indexPath.row] != nil){
        AVPlayerItem *tempPlayerItem = [AVPlayerItem playerItemWithURL:self.dataModel.VideoURLArray[indexPath.row]];
        [cell.player replaceCurrentItemWithPlayerItem:tempPlayerItem];
    }
    
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

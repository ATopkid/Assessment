//
//  DataModel.m
//  iOSAssessment
//
//  Created by helloworld on 17/5/20.
//  Copyright © 2017年 topkid. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

- (void)HTTPSRequest: (NSString*) URL{
    
    self.AuthorNameArray = [[NSMutableArray alloc] init];
    self.AuthorImageURLArray = [[NSMutableArray alloc] init];
    self.TimeArray = [[NSMutableArray alloc] init];
    self.VideoURLArray = [[NSMutableArray alloc] init];
    self.VideoTitleArray = [[NSMutableArray alloc] init];
    
    self.MyCell = [[MyTableViewCell alloc] init];
    
    NSURL *url = [NSURL URLWithString:URL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for (int i = 0; i < [dataDic[@"showapi_res_body"][@"pagebean"][@"contentlist"] count]; i++)
                {
                    NSString *ImageStr = dataDic[@"showapi_res_body"][@"pagebean"][@"contentlist"][i][@"profile_image"];
                    
                    [self.AuthorImageURLArray addObject:[NSURL URLWithString:ImageStr]];
                    
                    [self.VideoTitleArray addObject:dataDic[@"showapi_res_body"][@"pagebean"][@"contentlist"][i][@"text"]];
                    
                    [self.TimeArray addObject:dataDic[@"showapi_res_body"][@"pagebean"][@"contentlist"][i][@"create_time"]];
                    
                    NSString *videoStr = dataDic[@"showapi_res_body"][@"pagebean"][@"contentlist"][i][@"video_uri"];
                    [self.VideoURLArray addObject:[NSURL URLWithString:videoStr]];
                    
                    [self.AuthorNameArray addObject:dataDic[@"showapi_res_body"][@"pagebean"][@"contentlist"][i][@"name"]];
                }
                
                
                //发送刷新界面的消息
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTableViewNotification" object:self];
                
                });
        }else{
            NSLog(@"error------%@",error);
        }
    }];
    [dataTask resume];
}

@end

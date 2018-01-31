//
//  BillPhotoVC.m
//  TuLingApp
//
//  Created by hua on 2017/5/13.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BillPhotoVC.h"

@interface BillPhotoVC ()
{
    NSString *myStr;

    UIImageView *myView;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableDictionary *allDataDic;
@end

@implementation BillPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账单管理";
    [self requestData];
    myView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.view addSubview:myView];
    
}


#pragma mark--网络请求(列表)
- (void)requestData
{
//    __weak __typeof(self)weakSelf = self;
    _dataArray = [[NSMutableArray alloc]init];
    TLAccount *account = [TLAccountSave account];
    NSDictionary *params;
    if (account.uuid != nil) {
        params = @{@"uuid":account.uuid,@"billId":_str};
        [NetAccess getJSONDataWithUrl:kBillingPhoto parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
            int code = [[[responseObject objectForKey:@"header"] objectForKey:@"code"] intValue];
            if (code==0) {
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                arr  =[responseObject objectForKey:@"date"];
                myStr = arr[0][@"imgUrl"];
                if (myStr.length!=0) {
                     [myView sd_setImageWithURL:[NSURL URLWithString:myStr]];
                }
               
                
            
            }else{
                [MBProgressHUD showError:@"网络出错了"];
            }
            
            
        } fail:^{
            [MBProgressHUD showError:@"网络请求失败"];
        }];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end

//
//  EndorseSelectWhyVC.m
//  TuLingApp
//
//  Created by apple on 2017/12/23.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "EndorseSelectWhyVC.h"
#import "EndorseSelectWhyCell.h"

@interface EndorseSelectWhyVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation EndorseSelectWhyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"EndorseSelectWhyCell" bundle:nil] forCellReuseIdentifier:@"EndorseSelectWhyCell"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismiss)];
    [self.bgView addGestureRecognizer:tap];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
//    self.view.backgroundColor = [UIColor clearColor];
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    self.bgView.backgroundColor = [UIColor clearColor];
//    [self.bgView addSubview:effectView];
    self.tableViewHeight.constant = 44*self.dataArray.count;
}

- (void)tapDismiss {
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray new];
    }
    return _dataArray;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EndorseSelectWhyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EndorseSelectWhyCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textWayLabel.text = self.dataArray[indexPath.row][@"refundReasonText"];
    if ([[self.selectedReasonResult objectForKey:@"keyID"] isEqualToString: [self.dataArray[indexPath.row] objectForKey:@"keyID"]]) {
        cell.statusImageView.image = [UIImage imageNamed:@"selectflight_check_2"];
    } else {
        cell.statusImageView.image = [UIImage imageNamed:@"selectflight_uncheck"];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.endorseSelectWhy) {
        self.endorseSelectWhy(self.dataArray[indexPath.row]);
    }
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
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

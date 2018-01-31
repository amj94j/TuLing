//
//  BillingDetailCell.m
//  TuLingApp
//
//  Created by hua on 17/4/18.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BillingDetailCell.h"
#import "UIView+SDAutoLayout.h"
@implementation BillingDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *identifier = @"statuswwdsf";
    // 1.缓存中取
    BillingDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[BillingDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //设置cell被点击选择时的背景色为无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //账单编号
        _BillingNumber = [[UILabel alloc]init];
        _BillingNumber.font =[UIFont systemFontOfSize:15];
        _BillingNumber.textColor = [UIColor colorWithHexString:@"#919191"];
        _BillingNumber.frame = CGRectMake(15, 20, WIDTH-30, 20);
        [self addSubview:_BillingNumber];
        
        //账单周期
        _BillingTime = [[UILabel alloc]init];
        _BillingTime.font =[UIFont systemFontOfSize:15];
        _BillingTime.textColor = [UIColor colorWithHexString:@"#919191"];
        _BillingTime.frame = CGRectMake(15, CGRectGetMaxY(_BillingNumber.frame)+15, WIDTH-30, 20);
        [self addSubview:_BillingTime];
        
        //账单生成时间
        _BillingSetTime= [[UILabel alloc]init];
        _BillingSetTime.font =[UIFont systemFontOfSize:15];
        _BillingSetTime.textColor = [UIColor colorWithHexString:@"#919191"];
        _BillingSetTime.frame = CGRectMake(15, CGRectGetMaxY(_BillingTime.frame)+15, WIDTH-30, 20);
        [self addSubview:_BillingSetTime];
        
        
        //账单确认时间
        _BillingYesTime=[[UILabel alloc]init];
        _BillingYesTime.font =[UIFont systemFontOfSize:15];
        _BillingYesTime.textColor = [UIColor colorWithHexString:@"#919191"];
        _BillingYesTime.frame = CGRectMake(15, _BillingSetTime.frame.origin.y+15, WIDTH-30, 20);
        [self addSubview:_BillingYesTime];
        
        
        //账单金额
        _BillingMoney =[[UILabel alloc]init];
        _BillingMoney.font =[UIFont systemFontOfSize:15];
        _BillingMoney.textColor = [UIColor colorWithHexString:@"#919191"];
        
        _BillingMoney.text = @"账单金额：";
        _BillingMoney.frame = CGRectMake(15, _BillingYesTime.frame.origin.y+15, [NSString singeWidthForString:_BillingMoney.text fontSize:15 Height:20], 20);
        [self addSubview:_BillingMoney];
        
        
        //账单金额值
        _BillingMoneyValue=[[UILabel alloc]init];
        _BillingMoneyValue.font =[UIFont systemFontOfSize:15];
        _BillingMoneyValue.textColor = [UIColor colorWithHexString:@"#434343"];
        _BillingMoneyValue.frame = CGRectMake(CGRectGetMaxX(_BillingMoney.frame), _BillingYesTime.frame.origin.y+15,[NSString singeWidthForString:_BillingMoneyValue.text fontSize:15 Height:20], 20);
        [self addSubview:_BillingMoneyValue];
        
        //账单结算时间
        _Billing =[[UILabel alloc]init];
        _Billing.font =[UIFont systemFontOfSize:15];
        _Billing.textColor = [UIColor colorWithHexString:@"#919191"];
        _Billing.frame = CGRectMake(15, _BillingMoneyValue.frame.origin.y+15, WIDTH-30, 20);
        [self addSubview:_Billing];
        
        
        _buttonView = [[UIView alloc]init];
        _buttonView.frame =CGRectMake(15, _Billing.frame.origin.y+15, WIDTH-30, 30);
        _buttonView.backgroundColor  =[UIColor whiteColor];
        _buttonView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapg2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTap)];
        tapg2.numberOfTapsRequired = 1;
        [_buttonView addGestureRecognizer:tapg2];
        [self addSubview:_buttonView];
        
        UILabel *checkLabel = [createControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:15 Text:@"查看结算凭证" LabTextColor:RGBCOLOR(109, 203, 153)];
        [_buttonView addSubview:checkLabel];
        
        
        UILabel *linLab = [createControl createLineWithFrame:CGRectMake(0, 16, checkLabel.frame.size.width, 0.5) labelLineColor:RGBCOLOR(109, 203, 153)];
        [_buttonView addSubview:linLab];
        
        
        

    }
    return self;
}




-(void)setMyModel:(BillModel *)myModel
{
    //账单编号
    if ([NSString isBlankString:[NSString stringWithFormat:@"%@",myModel.billNumber]]) {
        
        _BillingNumber.text =[NSString stringWithFormat:@"账单编号：%@",myModel.billNumber];
    }
    
    
    //账单周期
    if ([NSString isBlankString:[NSString stringWithFormat:@"%@",myModel.billStartTime]]&&[NSString isBlankString:[NSString stringWithFormat:@"%@",myModel.billEndTime]]) {
        
        _BillingTime.text =[NSString stringWithFormat:@"账单周期：%@-%@",myModel.billStartTime,myModel.billEndTime];
    }
    
    
    //账单生成时间
    if ([NSString isBlankString:[NSString stringWithFormat:@"%@",myModel.createTime]]) {
        
        _BillingSetTime.text =[NSString stringWithFormat:@"账单生成时间：%@",myModel.createTime];
    }
    
    
    
    if ([NSString isBlankString:[NSString stringWithFormat:@"%@",myModel.billEnum]]) {
        
        //账单状态判断
        if ([[NSString stringWithFormat:@"%@",myModel.billEnum] isEqualToString:@"7"]) {
            //已结算
            _BillingYesTime.hidden=NO;
            _BillingMoney.hidden=NO;
            _buttonView.hidden=NO;
            
            _BillingMoneyValue.hidden=NO;
            _Billing.hidden=NO;
            
            
            //账单确认时间
            if ([NSString isBlankString:[NSString stringWithFormat:@"%@",myModel.shopEnterTime]]) {
                
                _BillingYesTime.text =[NSString stringWithFormat:@"账单确认时间：%@",myModel.shopEnterTime];
                _BillingYesTime.frame = CGRectMake(15, CGRectGetMaxY(_BillingSetTime.frame)+15, WIDTH-30, 20);
            }
            
            
            //账单金额
            if ([NSString isBlankString:[NSString stringWithFormat:@"%@",myModel.billCost]]) {
                
                _BillingMoney.frame = CGRectMake(15, CGRectGetMaxY(_BillingYesTime.frame)+15, [NSString singeWidthForString:_BillingMoney.text fontSize:15 Height:20], 20);
                _BillingMoneyValue.text =[NSString stringWithFormat:@"￥%@",myModel.billCost];
                _BillingMoneyValue.frame = CGRectMake(CGRectGetMaxX(_BillingMoney.frame), CGRectGetMaxY(_BillingYesTime.frame)+15,[NSString singeWidthForString:_BillingMoneyValue.text fontSize:15 Height:20], 20);
            }
            
            
            //账单结算时间
            if ([NSString isBlankString:[NSString stringWithFormat:@"%@",myModel.settleTime]]) {
                _Billing.text =[NSString stringWithFormat:@"账单结算时间：%@",myModel.settleTime];
                _Billing.frame = CGRectMake(15, CGRectGetMaxY(_BillingMoneyValue.frame)+15, WIDTH-30, 20);
            }
            
            _buttonView.frame =CGRectMake(15, CGRectGetMaxY(_Billing.frame)+15, WIDTH-30, 30);
            
            
            
            [self setupAutoHeightWithBottomViewsArray:@[_BillingMoney,_buttonView] bottomMargin:20];
        }else{
            //未结算相关
            
            _BillingYesTime.hidden=YES;
           
            _buttonView.hidden=YES;
            
             _BillingMoney.hidden=NO;
            _BillingMoneyValue.hidden=NO;
            _Billing.hidden=NO;
            
            //账单金额
            if ([NSString isBlankString:[NSString stringWithFormat:@"%@",myModel.billCost]]) {
                
                _BillingMoney.frame = CGRectMake(15, CGRectGetMaxY(_BillingSetTime.frame)+15, [NSString singeWidthForString:_BillingMoney.text fontSize:15 Height:20], 20);
                _BillingMoneyValue.text =[NSString stringWithFormat:@"￥%@",myModel.billCost];
                _BillingMoneyValue.frame = CGRectMake(CGRectGetMaxX(_BillingMoney.frame), CGRectGetMaxY(_BillingSetTime.frame)+15,[NSString singeWidthForString:_BillingMoneyValue.text fontSize:15 Height:20], 20);
                
                
                
                
            }
            
            
            
            [self setupAutoHeightWithBottomViewsArray:@[_BillingMoney] bottomMargin:20];
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
}

-(void)commentTap
{
    if (self.BtnClick1) {
        self.BtnClick1();
    }
    
    
}

@end

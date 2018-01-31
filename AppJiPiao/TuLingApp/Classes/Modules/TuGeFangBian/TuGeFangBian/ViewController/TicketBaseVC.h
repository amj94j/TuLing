//
//  TicketBaseVC.h
//  TuLingApp
//
//  Created by apple on 2017/12/5.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseVC.h"
#import "Masonry.h"
#import "Untils.h"
#import "CityModel.h"
#import "SearchFlightsModel.h"
#import "EndorseModel.h"

#define ScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define PXChange(r) ((ScreenWidth/750.f)*(r))
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define AppDelegateWindow [[[UIApplication sharedApplication] delegate] window]
#define kFont_PingFangSC @"PingFang SC"
#define kFont_PingFangSCSemibold @"PingFangSC-Semibold"

#define kColor_Line [UIColor colorWithHexString:@"#E2E2E2"]

// 域名
//#define kDomainName @"http://192.168.5.171:9093/"
//#define kDomainName @"http://192.168.1.171:9093/"
//#define kDomainName @"http://188j009c24.iask.in:8879/"
#define kDomainName @"http://47.93.114.200:9091/"

// 搜索
#define kPlaneTicketInfoList @"planeTicket/queryTicketInfoList"
// 热门城市
#define kPlaneTicketHotCity @"planeTicket/queryHotCity"
// 城市
#define kPlaneTicketCityList @"planeTicket/queryCity"
// 筛选条数
#define kPlaneTicketTicketListCount @"planeTicket/queryTicketListCount"
// 排序 筛选
#define kPlaneTicketTicketList @"planeTicket/queryTicketList"
// 查询航班信息
#define kPlaneTicketQueryFlightDeatil @"planeTicket/queryFlightDeatil"
// 查询机场
#define kPlaneTicketQueryAirportcon @"planeTicket/queryAirportcon"
// 查询航空公司
#define kPlaneTicketQueryCompanycon @"planeTicket/queryCompanycon"
// 查询保险产品信息
#define kPlaneTicketQueryInsuranceProduct @"insurance/queryInsuranceProduct"
// 查询乘机人列表信息
#define kPlaneTicketQuerySelctedFlightPerson @"basics/querySelctedFlightPerson"
// 乘机人操作：增删改查
#define kPlaneTicketFlightPersonAction @"basics/addFlightPerson"
// 获取乘客类型：成年人、儿童、婴儿
#define kPlaneTicketCheckPersonType @"basics/isPersonType"
// 地址操作：增删改查
#define kPlaneTicketQueryDetailedAddressList @"basics/queryDetailedAddressList"
// 创建订单
#define kPlaneTicketCreateOrder @"order/createOrder"
// 获取退改签规则
#define kPlaneTicketRulePro @"backChange/queryTicketrulePro"
// 获取改签申请理由能否改签
#define kPlaneCheckChangeTicket @"backChange/checkChangeTicket"

// 创建改签订单
#define kPlaneQueryAPPChangeTicketDetail @"backChange/creatChangeTicketDetail"
// 查询改签信息
#define kPlaneQuerySatisfyBackTicketOrder @"backChange/querySatisfyBackTicketOrder"
// 改签查询航班舱位政策
#define kPlaneQueryChangeFlightDeatil @"planeTicket/queryChangeFlightDeatil"
// 订单支付页面获取数据
#define kPlaneToOrderPay @"order/toOrderPay"
// 改签支付页面获取数据
#define kPlaneToChangeTicketPay @"backChange/toChangeTicketPay"
// 唤起支付接口
#define kPayOrderTouringPay @"payOrder/touringPay"
// 改签唤起支付接口
#define kPayOrderChangeTouringPay @"payOrder/changeTouringPay"


// 改签跳转的链接 单程
#define kUserInfoEndorseURL @"http://192.168.3.104:8099/applyChangeSub"
// 改签跳转的链接 往返
#define kUserInfoEndorseGBURL @"http://192.168.3.104:8099/applyChangegb"
// 申请改签跳转链接
#define kURL_ApplyDetails @"http://apptest.touring.com.cn/h5v2/airplane/applyDetails.html"
// 个人中心
#define kPersonalCenterURL  [NSString stringWithFormat:@"http://apptest.touring.com.cn/h5v2/airplane/personal.html?token=%@",kToken]


#define kToken @"5572622e39fee6d039942ac7d54610c2"


@interface TicketBaseVC : BaseVC
/**
 *  定制标题
 *
 *  @param titleName 标题名称
 */
- (void)addCustomTitleWithTitle:(NSString *)titleName;
// 标题 城市→城市
- (void)layoutNavigationItemViewGo:(NSString *)go back:(NSString *)back;

- (void)addRightBtnWithTitle:(NSString *)title iconName:(NSString *)iconName target:(id)target selector:(SEL)selector;
//是否为今天
- (BOOL)isToday:(NSDate*)date;
@end

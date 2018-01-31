#ifndef kInterface_h
#define kInterface_h
/**
 *  接口头文件
 *
 *
 *  CreateTime 5/20
 *
 *  Author 
 */


#ifdef DEBUG
//测试库公共头
#define kPublicHost @"http://apptest.touring.com.cn/"
#else
//测试库公共头
#define kPublicHost @"http://apptest.touring.com.cn/"
#endif

#ifdef DEBUG
//崩溃日志提交开发
#define kCrashType @"2"
#else
//测试
#define kCrashType @"2"

#endif

//2.0版本
#define yangChuanHost kPublicHost@"v1/interface/"
#define testHost kPublicHost@"touring2/interface/"
#define ktestWEB kPublicHost@"h5/#!/"

//3.0版本
//本地测试

#define yangChuanHostV1 kPublicHost@"v1/interface/"
#define yangChuanHostV5 kPublicHost@"v5/interface/"

#define yangChuanHostV2 kPublicHost@"v2/interface/"

//h5不带WWW
#define kInterfaceHost @"http://api.touring.com.cn/interface/"

/**
 V2.0版本 获取用户信息
 */
#define kTLMobileUserInfo (yangChuanHostV2@"mobileUsers/index")

/**
 上传系统信息
 */

#define KuploadSystemInfo (yangChuanHostV1@"mobileUsers/addDeviceInfo")
#define kH5Host1 (kPublicHost@"h5v2/account/")

#define Login_URL (kInterfaceHost@"users/login_with_token")
// 退款详情
#define kOrderFormReturnDetail (yangChuanHost@"shopOrders/returnDetail")
// 撤销退款
#define kOrderFormReturnCancel (yangChuanHost@"shopOrders/cancelReturn")
//支付宝验证是否成功
#define kalipayResult (yangChuanHost@"shopOrders/appPayNotify")
// 提交退款（post）
#define kOrderFormRetrunCreate (yangChuanHost@"shopOrderRetrun/create")
// 退款原因
#define kOrderFormRetrunReason (yangChuanHost@"shopOrderRetrun")
// 取消订单理由
#define kShopOrderDicItem (yangChuanHost@"dicItem")
// 订单详情
#define kShopOrderDetail (yangChuanHostV2@"shopOrders/detail")
// 取消订单
#define kShopOrderCancel (yangChuanHostV2@"shopOrders/shopCancel")
//校验短信验证码图片生成
#define kVerifyCodeImageURL (yangChuanHostV5@"code/code")
//检查用户名
#define kcheckUser (yangChuanHost@"mobileUsers/checkUser")
//好吃订单删除
#define kHaoChiOrderDelete    (kPublicHost@"adapter/order/deleteOrder")
//验证验证码
#define kcheckEmail (yangChuanHost@"mobileUsers/checkSms")
//注册
#define kcommitReg (yangChuanHost@"mobileUsers/register")
//发送验证码
#define ksendEmail (yangChuanHost@"mobileUsers/sendChangeSms")
//好吃订单取消
#define kHaoChiOrderCancel    (kPublicHost@"adapter/order/cancelOrder")
//好吃订单列表
#define kHaoChiOrderList   (kPublicHost@"adapter/order/list")
// 订单管理列表
#define kShopOrderList (yangChuanHostV2@"shopOrders/list")
//快捷登录发送验证码
#define kquickSendEmail (yangChuanHost@"mobileUsers/quickSendSms")
//快捷登录
#define kquickLogin (yangChuanHost@"mobileUsers/quickLogin")
//用户普通登录
#define kuserLogin (yangChuanHost@"mobileUsers/login")
//三方登陆
#define kotherLogin (yangChuanHost@"mobileUsers/thirdPartyRegistration")
// 确认收货
#define kOrderFormConfirm (yangChuanHost@"shopOrders/confirm")
// 退款详情
#define kShopOrderReturnDetail (yangChuanHostV2@"shopOrders/returnDetail")
// 退款列表
#define kShopOrderReturnList (yangChuanHostV2@"shopOrders/returnList")
// 取消订单理由
#define kOrderFormCancelReason (yangChuanHost@"shopOrders/cancelReason")
// 我的订单列表
#define kOrderFormList (yangChuanHost@"shopOrders/list")
// 订单付款
#define kOrderFormOrderPay (yangChuanHost@"shopOrders/orderPay")
//支付方式初始化接口
#define kGetOrder (yangChuanHost@"shopOrders/confirmPayment")
// 订单详情
#define kOrderFormDetail (yangChuanHost@"shopOrders/orderDetail")
#endif /* kInterface_h */

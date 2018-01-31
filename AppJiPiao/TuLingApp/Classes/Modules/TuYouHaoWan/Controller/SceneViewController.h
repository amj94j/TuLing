#import "BaseViewController.h"

@interface SceneViewController : BaseViewController

@property(nonatomic,assign) NSInteger currentInteger;

@property(nonatomic,assign)NSInteger sceneTag;

@property (nonatomic, strong) UIScrollView *scrollView;
/**图片View*/
@property (nonatomic, strong) UIView *photoView;
/**列表tableView*/
@property (nonatomic, strong) UITableView *lineTableView;
/**列表数据*/
@property (nonatomic, strong) NSMutableArray *lineDateArray;
/**轮播图数据图片**/
@property(nonatomic,strong) NSMutableArray *imageArrays;
/**主题图片**/
@property(nonatomic,strong)NSMutableArray *specialTopicArrays;
/**主题标题**/
@property(nonatomic,strong)NSMutableArray *specialTitleArrays;
/**list主题**/
@property(nonatomic,strong)NSMutableDictionary *listDic;

@end

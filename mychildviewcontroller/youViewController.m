//
//  youViewController.m
//  mychildviewcontroller
//
//  Created by xiantian on 16/3/23.
//  Copyright © 2016年 xiantian. All rights reserved.
//

#import "youViewController.h"
#import "firstViewController.h"
#import "secondViewController.h"
#import "thirdViewController.h"
@interface youViewController ()

@property (nonatomic ,strong) firstViewController *firstvc;
@property (nonatomic ,strong) secondViewController *secondvc;
@property (nonatomic ,strong) thirdViewController *thirdvc;
@property (nonatomic,strong)  UIViewController *currentvc;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) UIScrollView *headScrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic,weak) UIButton *selectedbutton;

@end

@implementation youViewController

- (void)loadView{
    [super loadView];
    [self initialization];
}

- (void)initialization{
    self.itemArray = [NSMutableArray arrayWithObjects:@"微博问答",@"贤二动画",@"贤二漫画", nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBaseUI];
}

- (void)loadBaseUI{
    self.title = @"首页";
    
    _headScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    _headScrollView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    for (int i = 0; i<_itemArray.count; i++) {
        
        UIButton *itemButton = [[UIButton alloc]initWithFrame:CGRectMake(i*([UIScreen mainScreen].bounds.size.width/_itemArray.count), 20, [UIScreen mainScreen].bounds.size.width/_itemArray.count, 64)];
        itemButton.tag = 100+i;
        itemButton.backgroundColor = [UIColor clearColor];
//        NSDictionary *dic = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:16.0f]};
//        [itemButton setAttributedTitle:[[NSAttributedString alloc]initWithString:_itemArray[i] attributes:dic] forState:UIControlStateNormal];
       
        [itemButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [itemButton setTitleColor:[UIColor purpleColor] forState:UIControlStateSelected];
        
        if (i == 0) {
            [self mybuttonclick:itemButton];
        }

        [itemButton setTitle:_itemArray [i] forState:UIControlStateNormal];
        [itemButton.titleLabel  setFont:[UIFont systemFontOfSize:16.0]];
        [itemButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headScrollView addSubview:itemButton];
    }
    [_headScrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
    _headScrollView.showsHorizontalScrollIndicator = NO;
    _headScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_headScrollView];
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0,64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -64)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentView];
    
    [self addSubControllers];
}


#pragma mark - privatemethods
- (void)addSubControllers{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    _firstvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"firstViewController"];
  
   _secondvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"secondViewController"];
    
    _thirdvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"thirdViewController"];
    
    [self addChildViewController:_firstvc];
    
    [self addChildViewController: _secondvc];
    
    [self addChildViewController:_thirdvc];
    
    //调整子视图控制器的Frame已适应容器View
    [self fitFrameForChildViewController:_firstvc];
    
    //设置默认显示在容器View的内容
    [self.contentView addSubview:_firstvc.view];
    
    _currentvc = _firstvc;
}

- (void)buttonClick:(UIButton *)sender{
    
    [self mybuttonclick:sender];

    if ((sender.tag == 100 && _currentvc == _firstvc) || (sender.tag == 101 && _currentvc == _secondvc) || (sender.tag == 102 && _currentvc == _thirdvc)) {
        return;
    }
    switch (sender.tag) {
        case 100:{
            [self fitFrameForChildViewController:_firstvc];
            [self transitionFromOldViewController:_currentvc toNewViewController:_firstvc];
            
        }
            break;
        case 101:{
            [self fitFrameForChildViewController:_secondvc];
            [self transitionFromOldViewController:_currentvc toNewViewController:_secondvc];
            
        }
            break;
        case 102:{
            [self fitFrameForChildViewController:_thirdvc];
            [self transitionFromOldViewController:_currentvc toNewViewController:_thirdvc];
        }
            break;
    }
}

// 监听按钮点击
-(void)mybuttonclick:(UIButton *)button{
    //  让当前点击的按钮取消点击
    self.selectedbutton.selected = NO;
    //新点击的按钮称为选中状态
    button.selected = YES;
    //新点击的按钮就成为当前点击的按钮
    self.selectedbutton = button;
}

- (void)fitFrameForChildViewController:(UIViewController *)chileViewController{
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    chileViewController.view.frame = frame;
}

//转换子视图控制器
- (void)transitionFromOldViewController:(UIViewController *)oldViewController toNewViewController:(UIViewController *)newViewController{
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newViewController didMoveToParentViewController:self];
            _currentvc = newViewController;
        }else{
           _currentvc = oldViewController;
        }
    }];
    
}

//移除所有子视图控制器
- (void)removeAllChildViewControllers{
    for (UIViewController *vc in self.childViewControllers) {
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }
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

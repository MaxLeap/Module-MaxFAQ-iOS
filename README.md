# Module-MaxFAQ-iOS

## 使用说明：

### 一、设置 appid 和 clientkey

1、在 maxleap.cn 中创建 app，记录 appid 和 clientkey。

2、更换 AppDelegate.m 中的宏定义为1中的 appid 和 clientkey：

    #define MAXLEAP_APPID           @"your_app_id"
    #define MAXLEAP_CLIENTKEY       @"your_client_key"

### 二、ViewController 介绍

1、HCSectionListViewController：FAQ 入口界面，使用方法：

    HCSectionListViewController *faqViewController = [[HCSectionListViewController alloc] init];
    [self.navigationController pushViewController:faqViewController animated:YES];

**注意：必须使用 NavigationController, 否则无法导航到 FAQ 下级界面**
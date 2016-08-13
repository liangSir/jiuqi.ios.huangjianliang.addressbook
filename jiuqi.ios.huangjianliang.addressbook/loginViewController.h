//
//  loginViewController.h
//  jiuqi.ios.huangjianliang.addressbook
//
//  Created by 黄建亮 on 8/10/16.
//  Copyright © 2016 jiuqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BOOL recordPwd;
    BOOL autoLogin;
}
@property (retain,nonatomic)UIImageView *recordBtn;
@property (retain,nonatomic)UIImageView *autoBtn;
@property (retain,nonatomic)NSMutableArray *cellRightArray;

- (void)readUserInfoFromFile;
- (void)recoredBtnClick;
- (void)autoBtnClick;
- (void)writePasswordToFile;


@end


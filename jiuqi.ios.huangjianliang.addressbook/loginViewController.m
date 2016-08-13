//
//  loginViewController.m
//  jiuqi.ios.huangjianliang.addressbook
//
//  Created by 黄建亮 on 8/10/16.
//  Copyright © 2016 jiuqi. All rights reserved.
//
#define USERNAME @"username"
#define PASSWORD @"password"

#import "loginViewController.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"

@interface loginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation loginViewController

@synthesize recordBtn;
@synthesize autoBtn;
@synthesize cellRightArray;













- (void)viewDidLoad {
    [super viewDidLoad];
//     Do any additional setup after loading the view.
    [_username addTarget:self action:@selector(textChange) forControlEvents:
     UIControlEventEditingChanged];
    
    [_password addTarget:self action:@selector(textChange) forControlEvents:
     UIControlEventEditingChanged];
    
    
    cellRightArray = [[NSMutableArray alloc]init];//作为属性变量的数组如果不初始化是不能用的，这个数组用来保存UITextFiled中的用户名和密码。
    recordPwd = NO;//刚开始把是否保存密码设置为NO
    autoLogin = NO;//刚开始把自动登录设置为NO
    
    //这个就是那个带钩的小框框，之前尝试用UIButton，但是不好切换button的backgroundView，所以就换了UIImageView,给它添加手势。
    recordBtn = [[UIImageView alloc]init];
    recordBtn.frame = CGRectMake(75, 440, 20, 20);
    recordBtn.userInteractionEnabled = YES;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 430, 100, 40)];
    label.text = @"记住密码";
    
    //自动登录checkbox
    autoBtn = [[UIImageView alloc]init];
    autoBtn.frame = CGRectMake(210, 440, 20, 20);
    autoBtn.userInteractionEnabled = YES;
    UILabel *autolabel = [[UILabel alloc]initWithFrame:CGRectMake(235, 430, 100, 40)];
    autolabel.text = @"自动登录";
    
    
    [self.view addSubview:label];
    [self.view addSubview:autolabel];
  //  [label release];
    
    //一.“记住密码” 的判断
    //添加了一个手势，单击触发事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recoredBtnClick)];
    //点击一下
    tapGesture.numberOfTapsRequired = 1;
    //这里注意是在UIImageView上添加手势
    [recordBtn addGestureRecognizer:tapGesture];
    //这里注意是在UIImageView上添加手势
    [self readUserInfoFromFile];//在图片初始化之前先读取plist文件，判断recordPwd
    
    if (recordPwd) {
        recordBtn.image = [UIImage imageNamed:@"check_on"];
    }
    else{
        recordBtn.image = [UIImage imageNamed:@"check_off"];
    }
    
    //二.“自动登录”勾选框的实现
    //添加了一个手势，单击触发事件
    UITapGestureRecognizer *autotapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(autoBtnClick)];
    //点击一下
    autotapGesture.numberOfTapsRequired = 1;
    //这里注意是在UIImageView上添加手势
    [autoBtn addGestureRecognizer:autotapGesture];
    //这里注意是在UIImageView上添加手势
    [self readUserInfoFromFile];//在图片初始化之前先读取plist文件，判断recordPwd
    
    if (autoLogin) {
        autoBtn.image = [UIImage imageNamed:@"check_on"];
    }
    else{
        autoBtn.image = [UIImage imageNamed:@"check_off"];
    }
    
    
    [self.view addSubview:recordBtn];
    [self.view addSubview:autoBtn];
    
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    self.recordBtn = nil;
    self.autoBtn = nil;
}
- (void)readUserInfoFromFile//从plist读取数据
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    //以上的三句话获取沙盒中data.plist的路径。
    NSLog(@"文件路径：%@",path);
    //从该路径读取文件，注意这里是读取，跟创建plist的init方法不同，看下面就知道了
    NSMutableDictionary *saveStock = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    //@"recordPwd"是一个key，存到字典何从字典中取值都要用到
    recordPwd = [[saveStock objectForKey:@"recordPwd"]boolValue];
    
    if (!recordPwd)
    {
        _username.text = @"";
        _password.text = @"";
        //移除字典内所有元素
        [saveStock removeAllObjects];
    }
    else{
        _username.text = [saveStock objectForKey:USERNAME];
        _password.text = [saveStock objectForKey:PASSWORD];
        //密码设置为暗文
        //        [pswTextField setSecureTextEntry:YES];
    }
    NSLog(@"_username.text==%@,_password.text=%@",_username.text,_password.text);
    NSLog(@"读取saveStock=%@",saveStock);
    //    [saveStock release];
}

//把是否记住密码信息写进data.plist文件
- (void)writePasswordToFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    NSLog(@"filePath:%@",path);
    
    //字典初始化，注意这里的init方法，跟-(void)readUserInfoFromFile方法中的字典初始化方法不同。
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    NSLog(@"self.cellRightArray=%@",self.cellRightArray);
    
    //如果输入不为空
    if (_username.text.length != 0||_password.text.length != 0) {
        //用户名和密码存入字典，这里的key用了宏定义，其实@"recordPwd"也可以用，在文中多次使用比较省事
        [data setObject:_username.text forKey:USERNAME];
        [data setObject:_password.text forKey:PASSWORD];
    }
    [data setObject:[NSNumber numberWithBool:recordPwd] forKey:@"recordPwd"];
    [data writeToFile:path atomically:YES];
    NSLog(@"是否记住密码信息==%@",data);
    //    [data release];
}


//点击是否记住密码
- (void)recoredBtnClick
{
    //当记住密码不被勾选时，自动登录不能被勾选
//    if((recordPwd = NO)){
//        autoLogin = NO;
//    }
    UIImage *image = [[UIImage alloc]init];
    if (recordPwd) {
        //当勾选框没被选中（状态为“0”）时，设置图片为空的
        recordBtn.image = [UIImage imageNamed:@"check_off"];
        recordPwd = NO;
        autoBtn.image = [UIImage imageNamed:@"check_off"];
        autoLogin = NO;
    }
    else{
        recordBtn.image = [UIImage imageNamed:@"check_on"];
        recordPwd = YES;
    }
    [self writePasswordToFile];
    //    [image release];
}

//点击是否自动登录
- (void)autoBtnClick
{
    //当自动登录被勾选时，记住密码自动被勾选
//    if((autoLogin = YES))
//    {
//        recordPwd = YES;
//    }
    UIImage *image = [[UIImage alloc]init];
    if (autoLogin) {
        //当勾选框没被选中（状态为“0”）时，设置图片为空的
        autoBtn.image = [UIImage imageNamed:@"check_off"];
        autoLogin = NO;
    }
    else{
        autoBtn.image = [UIImage imageNamed:@"check_on"];
        autoLogin = YES;
        recordBtn.image = [UIImage imageNamed:@"check_on"];
        recordPwd = YES;
        
    }
}
//点击空白处隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_username resignFirstResponder];
    [_password resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)login:(id)sender {
    // 判断用户输入的账号和密码是否正确
    if ([_username.text isEqualToString:@"liang"] &&
        [_password.text isEqualToString:@"123"]) {
        // 账号和密码正确
        // 显示遮盖：只要做一些比较耗时的操作最好用遮盖
        [MBProgressHUD showMessage:@"正在登录中"];
        
        // GCD
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 移除遮盖
            [MBProgressHUD hideHUD];
            
            
            // 执行segue
            [self performSegueWithIdentifier:@"logincontact" sender:nil];
            
        });
    }else{ // 不正确
        // MBProgressHud:提示框
        [MBProgressHUD showError:@"账号或者密码错误"];
    }
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)textChange
{
    //判断两个文本框的内容
    _loginBtn.enabled = _username.text.length  && _password.text.length ;
    NSLog(@"%@ ",_username.text);
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

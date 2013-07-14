iOS-ORM
=======

iOS-ORM

写sql你很烦？
但缓存、本地收藏、本地数据…这些功能都需要使用sqlite需要写sql.

iOS-ORM,iOS上的对象关系映射。让你不需要关心db、table、sql，你只需要关心model即可

iOS-ORM,封装了普通的增、删、改、查功能。

你只需要这样：
>
    UserDao *userDao = [[[UserDao alloc] init] autorelease];
    for (int x = 0; x < 20; x++) {
        User * user = [[[User alloc] init] autorelease];
        user.userID     = [NSString stringWithFormat:@"3243343%d",x];
        user.userName   = [NSString stringWithFormat:@"ijarobot-%d",x];
        user.signature  = @"二流程序猿";
        user.userDesc   = @"还是一个坏程序猿";    
        [userDao insert:user];
    }
    


就能未完成…如下图

![dbresult icon](https://github.com/ijarobot/iOS-ORM/blob/master/iOS-ORM/Screenshot/67599EFE-DDBC-448D-8715-3A0BAE857031.png)
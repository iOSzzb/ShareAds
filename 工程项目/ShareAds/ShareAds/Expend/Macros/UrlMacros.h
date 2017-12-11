//
//  UrlMacros.h
//  PartyBuilding
//
//  Created by 张振波 on 2017/4/23.
//  Copyright © 2017年 张振波. All rights reserved.
//
#ifdef DEBUG
//#define MAIN_URL @"http://tuijiehui.witfort.net/"
#define MAIN_URL @"http://api.tjh-app.com:8580/"
#define WX_APPID @"wx200417008bf14976"
#else
#define MAIN_URL @"http://api.tjh-app.com:8580/"
#define WX_APPID @"wx200417008bf14976"
#endif
#define QQ_APP_ID @"1106230429"
#define API_URL [NSString stringWithFormat:@"%@%@",MAIN_URL,@"tjh/appPost.do"]
#define FILE_UPLOAD_URL [NSString stringWithFormat:@"%@%@",MAIN_URL,@"tjh/fileUpload.do"]

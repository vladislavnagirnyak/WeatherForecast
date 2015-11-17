//
//  inc.h
//  App
//
//  Created by Влад Нагирняк on 15.11.15.
//  Copyright (c) 2015 Влад Нагирняк. All rights reserved.
//

#ifndef App_inc_h
#define App_inc_h

#define NS_DIRECTORY_DOCUMENTS [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define NS_IN_DOCUMENTS(fileName) [NS_DIRECTORY_DOCUMENTS stringByAppendingPathComponent:fileName]

#endif

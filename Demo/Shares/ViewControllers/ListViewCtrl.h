//
//  ListViewCtrl.h
//  Demo
//
//  Created by leihui on 13-4-10.
//
//

#import <UIKit/UIKit.h>
#import "JTListView.h"

@interface ListViewCtrl : UIViewController <UIActionSheetDelegate, JTListViewDataSource, JTListViewDelegate>
{
    JTListView          *_listView;
}

@end

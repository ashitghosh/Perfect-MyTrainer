//
//  DrawerViewController.h
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 10/02/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerCell.h"
#import "MyPerfectTrainer-Swift.h"



@interface DrawerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate,NSURLSessionDataDelegate,NSURLSessionTaskDelegate>{
    NSMutableArray *arrDrawer, *arrImage;
    NSString *total_unread_counter;
}
@property (strong, nonatomic) IBOutlet UITableView *Drawer_table_view;

@end

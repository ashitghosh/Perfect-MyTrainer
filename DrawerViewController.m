//
//  DrawerViewController.m
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 10/02/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

#import "DrawerViewController.h"

@interface DrawerViewController ()

@end

@implementation DrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrDrawer=[[NSMutableArray alloc]initWithObjects:@"Home",@"View Profile",@"Edit Profile",@"Search",@"My Schdule",@"Message",@"Invoice",@"Logout", nil];
     arrImage=[[NSMutableArray alloc]initWithObjects:@"homeicon.png",@"profileicon.png",@"edit-profile.png",@"search.png",@"schedule.png",@"massage.png",@"invoice.png",@"logout.png", nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrDrawer count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"DrawerCell";
    
    DrawerCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[DrawerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.Name_lbl.text = [arrDrawer objectAtIndex:indexPath.row];
    cell.Drawer_icon.image=[UIImage imageNamed:[arrImage objectAtIndex:indexPath.row]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

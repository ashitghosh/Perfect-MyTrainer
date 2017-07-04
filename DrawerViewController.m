//
//  DrawerViewController.m
//  MyPerfectTrainer
//
//  Created by Amar Banerjee on 10/02/17.
//  Copyright © 2017 Ogma Conceptions. All rights reserved.
//

#import "DrawerViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface DrawerViewController ()

@end

@implementation DrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    total_unread_counter=[[NSString alloc]init];
    
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
    NSString *Menu=[NSString stringWithFormat:@"%@",[arrDrawer objectAtIndex:indexPath.row]];
    if ([Menu isEqualToString:@"Notification"]) {
        if ([total_unread_counter isEqualToString:@""]||[total_unread_counter isEqualToString:@"0"]) {
           cell.Name_lbl.text = [arrDrawer objectAtIndex:indexPath.row];
        }
        else{
         cell.Name_lbl.text = [NSString stringWithFormat:@"%@ (%@)",[arrDrawer objectAtIndex:indexPath.row],total_unread_counter];
        }
     
    }
    else{
    cell.Name_lbl.text = [arrDrawer objectAtIndex:indexPath.row];
    }
    
    cell.Drawer_icon.image=[UIImage imageNamed:[arrImage objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return cell;
}

-(void)viewWillAppear:(BOOL)animated{
    NSString *user_type=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_type"]];
    NSLog(@"user_type = %@",user_type);
    if ([user_type isEqualToString:@"trainer"]) {
        arrDrawer=[[NSMutableArray alloc]initWithObjects:@"Home",@"My Package",@"My Schedule",@"User booking",@"Work Schedule",@"Message",@"My Post",@"Notification",@"Logout", nil];
        arrImage=[[NSMutableArray alloc]initWithObjects:@"homeicon.png",@"invoice.png.png",@"schedule.png",@"schedule.png",@"massage.png",@"invoice.png",@"schedule.png",@"bell.png",@"logout.png", nil];
    }
    else{
        arrDrawer=[[NSMutableArray alloc]initWithObjects:@"Home",@"Edit Profile",@"Search",@"My Schedule",@"Message",@"Invoice",@"Notification",@"Logout", nil];
        arrImage=[[NSMutableArray alloc]initWithObjects:@"homeicon.png",@"profileicon.png",@"edit-profile.png",@"schedule.png",@"schedule.png",@"massage.png",@"bell.png",@"logout.png", nil];
    }
    [self.Drawer_table_view reloadData];
   // [self NotificationCount];
    
   
  }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath{
    [tableView deselectRowAtIndexPath:newIndexPath animated:YES];
    
    KYDrawerController  *elDrawer = (KYDrawerController*)self.navigationController.parentViewController;
    NSString *user_type=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_type"]];
    NSLog(@"%ld",(long)newIndexPath.row);
    
    switch ([newIndexPath row]) {
        case 0:{
            if ([user_type isEqualToString:@"trainer"]) {
                TrainerAboutController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainerAboutController"];
                UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:viewController];
                elDrawer.ViewController=navController;
                [elDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
            else{
                ClientHomeController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ClientHomeController"];
                UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:viewController];
                elDrawer.ViewController=navController;
                [elDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
            
            break;
        }
        case 1:{
            if ([user_type isEqualToString:@"trainer"]) {
                TrainerMyPackageController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainerMyPackageController"];
                UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:viewController];
                elDrawer.ViewController=navController;
                [elDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
            else{
                ClientEditViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ClientEditViewController"];
                UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:viewController];
                elDrawer.ViewController=navController;
                [elDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
            break;
            
        }
        case 2:{
            if ([user_type isEqualToString:@"trainer"]) {
                MySchduleController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MySchduleController"];
                viewController.IsNotComeFromDrawer=false;
                UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:viewController];
                elDrawer.ViewController=navController;
                [elDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
            else{
                
            }
            break;
            
        }
            
        case 3:{
            if ([user_type isEqualToString:@"trainer"]) {
                
                TrainerScheduleListView *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainerScheduleListView"];
                UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:viewController];
                elDrawer.ViewController=navController;
                [elDrawer setDrawerState:DrawerStateClosed animated:YES];
                
               
            }
            else{
                ClientMyScheduleController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ClientMyScheduleController"];
                UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:viewController];
                elDrawer.ViewController=navController;
                [elDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
            break; 
            
        }
            
        case 4:{
            if ([user_type isEqualToString:@"trainer"]) {
                WorkSchduleCreateView *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WorkSchduleCreateView"];
                UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:viewController];
                elDrawer.ViewController=navController;
                [elDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
            else{
                MessageViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageViewController"];
                viewController.IsNotComeFromClient=false;
                UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:viewController];
                elDrawer.ViewController=navController;
                [elDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
            
            break;
        }
            
        case 5:{
            if ([user_type isEqualToString:@"trainer"]) {
                MessageViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageViewController"];
                viewController.IsNotComeFromClient=true;
                UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:viewController];
                elDrawer.ViewController=navController;
                [elDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
            else{
                ClientInvoiceController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ClientInvoiceController"];
                UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:viewController];
                elDrawer.ViewController=navController;
                [elDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
            
            
            break;
        }
        case 6:{
            if ([user_type isEqualToString:@"trainer"]) {
                
                TrainerMyPostController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainerMyPostController"];
                UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:viewController];
                elDrawer.ViewController=navController;
                [elDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
            else{
               
                ClientNotificationController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ClientNotificationController"];
                
                UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:viewController];
                elDrawer.ViewController=navController;
                [elDrawer setDrawerState:DrawerStateClosed animated:YES];
    
            }
            break;
        }
        case 7:{
            if ([user_type isEqualToString:@"trainer"]) {
                NotificationViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotificationViewController"];
                
                UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:viewController];
                elDrawer.ViewController=navController;
                [elDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
            else{
                [FBSDKAccessToken setCurrentAccessToken:nil];
                NSLog(@"Current Token=%@",[FBSDKAccessToken currentAccessToken]);
                ViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainController"];
                UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:viewController];
                elDrawer.ViewController=navController;
                [elDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
            break;
        }

            
        case 8:{
            if ([user_type isEqualToString:@"trainer"]) {
                [FBSDKAccessToken setCurrentAccessToken:nil];
                ViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainController"];
                UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:viewController];
                elDrawer.ViewController=navController;
                [elDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
            else{
               
            }
            break;
        }

            
       
            
        default:{
//            [viewController.view setBackgroundColor:[UIColor whiteColor]];
//            elDrawer.mainViewController=navController;
//            [elDrawer setDrawerState:DrawerStateClosed animated:YES];
            break;
        }
            
            
            
            
    }
}

-(void)NotificationCount{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD show];
    NSString *str;
    NSString *user_type=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_type"]];
    NSLog(@"user_type = %@",user_type);
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    if ([user_type isEqualToString:@"trainer"]) {
        [dict setValue: [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] forKey:@"trainer_id"];
        str=@"http://ogmaconceptions.com/demo/my_perfect_trainer/MyPerfectTrainerApp/trainerUnreadCounter";
    }
    else{
    [dict setValue: [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] forKey:@"client_id"];
        str=@"http://ogmaconceptions.com/demo/my_perfect_trainer/ClientApp/clientUnreadCounter";
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict // Here you can pass array or dictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //This is your JSON String
        //NSUTF8StringEncoding encodes special characters using an escaping scheme
    } else {
        NSLog(@"Got an error: %@", error);
        jsonString = @"";
    }
    NSLog(@"Your JSON String is %@", jsonString);

    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];
    
    // Setup the request with URL
    
    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    // Convert POST string parameters to data using UTF8 Encoding
    NSData *postData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Convert POST string parameters to data using UTF8 Encoding
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:postData];
    
    // Create dataTask
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // Handle your response here
        if (!error) {
          [SVProgressHUD dismiss];
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&error];
            NSLog(@"Json%@",json);
            if ([[json valueForKey:@"status"] boolValue]==0) {
                total_unread_counter=[NSString stringWithFormat:@"%@",[json valueForKey:@"total_unread_notification"]];
                [self.Drawer_table_view reloadData];
               
            }
            else{
            [self.Drawer_table_view reloadData];
            }
            
            
        }
        else{
        [SVProgressHUD dismiss];
             [self.Drawer_table_view reloadData];
        }
        
    }];
    
    // Fire the request
    [dataTask resume];
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

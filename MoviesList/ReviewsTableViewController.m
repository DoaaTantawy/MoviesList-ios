//
//  ReviewsTableViewController.m
//  MoviesList
//
//  Created by Doaa Tantawy on 8/7/1440 AH.
//  Copyright © 1440 AH Doaa Tantawy. All rights reserved.
//

#import "ReviewsTableViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface ReviewsTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *reviewsTable;


@end

@implementation ReviewsTableViewController
NSString *reviewUrl;
NSMutableArray *reviewsT;

- (void)viewDidLoad {
    [super viewDidLoad];

   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    printf("view will appear\n");
    [self getReviews];
}

-(void)getReviews{
    reviewUrl=@"https://api.themoviedb.org/3/movie/";
    reviewUrl=[reviewUrl stringByAppendingString:_movieID];
    reviewUrl=[reviewUrl stringByAppendingString:@"/reviews?api_key=8b1cad7914e5aefb8190b0493bfae7a0"];
    NSURL *URL = [NSURL URLWithString:reviewUrl];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            // NSLog(@"%@",responseObject);
            reviewsT=(NSMutableArray *) responseObject[@"results"];
            [self->_reviewsTable reloadData];
            
            
        }
    }];
    [dataTask resume];
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numOfRow=reviewsT.count;
    return numOfRow;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *dict=(NSDictionary *) reviewsT[indexPath.row];
    
    cell.textLabel.text=[dict objectForKey:@"author"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict=(NSDictionary *) reviewsT[indexPath.row];
    NSURL* url = [[NSURL alloc] initWithString:[dict objectForKey:@"url"]];
    [[UIApplication sharedApplication] openURL: url];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

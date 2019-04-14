//
//  FavMoivesTableViewController.m
//  MoviesList
//
//  Created by Doaa Tantawy on 8/3/1440 AH.
//  Copyright © 1440 AH Doaa Tantawy. All rights reserved.
//

#import "FavMoivesTableViewController.h"
#import "DBManager.h"
#import "DetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FavMoivesTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *myTable;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrmovieInfo;

@end

@implementation FavMoivesTableViewController
DetailsViewController *movieFav;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"themoviedb.sql"];
    
    movieFav= [self.storyboard instantiateViewControllerWithIdentifier:@"movieVC"];
    
    [self loadData];
}

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from movieFav";
    
    // Get the results.
    if (self.arrmovieInfo != nil) {
        self.arrmovieInfo = nil;
    }
    self.arrmovieInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self->_myTable reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numbOfRow=_arrmovieInfo.count;
    
    return numbOfRow;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *img=[cell viewWithTag:1];
    UILabel *title=[cell viewWithTag:2];
    NSString *imgUrl=@"http://image.tmdb.org/t/p/w185/";
    imgUrl = [imgUrl stringByAppendingString: [NSString stringWithFormat:@"%@", [[self.arrmovieInfo objectAtIndex:indexPath.row] objectAtIndex:3]]];
    
    [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imgUrl]]
                            placeholderImage:[UIImage imageNamed:@"holderImg.jpg"]];
    title.text=[[self.arrmovieInfo objectAtIndex:indexPath.row] objectAtIndex:2];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    movieFav.recordIDToEdit = [[[self.arrmovieInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    movieFav.favouriteOrNot=2;
    [self.navigationController pushViewController:movieFav animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the selected record.
        // Find the record ID.
        int recordIDToDelete =[[[self.arrmovieInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        // Prepare the query.
        NSString *query = [NSString stringWithFormat:@"delete from movieFav where movieInfoID=%d", recordIDToDelete];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // Reload the table view.
        [self loadData];
    }
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

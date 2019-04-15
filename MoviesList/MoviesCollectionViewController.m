//
//  MoviesCollectionViewController.m
//  MoviesList
//
//  Created by Doaa Tantawy on 8/2/1440 AH.
//  Copyright © 1440 AH Doaa Tantawy. All rights reserved.
//

#import "MoviesCollectionViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "DetailsViewController.h"
#import "DBManager.h"

@interface MoviesCollectionViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UICollectionView *myCollection;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrmovieInfo;

@end

@implementation MoviesCollectionViewController
NSDictionary *parameters;
NSMutableArray *contacts;
DetailsViewController *movie;
NSURL *URL;


static NSString * const reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"themoviedb.sql"];
    
    movie= [self.storyboard instantiateViewControllerWithIdentifier:@"movieVC"];
    
    URL = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/popular?api_key=8b1cad7914e5aefb8190b0493bfae7a0"];
    
    [self getDataFromApi:URL];
 
}



-(void)getDataFromApi:(NSURL*) URL{
    NSString *querySelect= @"select * from movieInfo";
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            // NSLog(@"%@ %@", response, responseObject);
           // [SDWebImageManager.sharedManager.imageCache clearMemory] ;
            
            contacts = (NSMutableArray*) responseObject[@"results"];
            NSString *query;
            int count=(int)contacts.count;
            NSString *queryDelete = [NSString stringWithFormat:@"delete from movieInfo"];
            [self.dbManager executeQuery:queryDelete];
            
            for(int i=0; i<count; i++){
                NSDictionary *dict =(NSDictionary *)contacts[i];
                query = [NSString stringWithFormat:@"insert into movieInfo(movieInfoID,mid ,title, poster_path ,backdrop_path,original_title ,overview,release_date, vote_average) values(null, \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\",\"%@\")",[dict objectForKey: @"id"], [dict objectForKey: @"title"], [dict objectForKey: @"poster_path"], [dict objectForKey: @"backdrop_path"], [dict objectForKey: @"original_title"], [dict objectForKey: @"overview"], [dict objectForKey: @"release_date"], [dict objectForKey: @"vote_average"]];
                [self.dbManager executeQuery:query];
                
                // If the query was successfully executed then pop the view controller.
                if (self.dbManager.affectedRows != 0) {
                    NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
                }
                else{
                    NSLog(@"Could not execute the query.");
                }
                
            }
            
        }
    }];
    [dataTask resume];
    [self loadData:querySelect];
}

-(void)getDataFromApiTopRated:(NSURL*) URL{
    NSString *querySelect= @"select * from movieTopRated";
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            // NSLog(@"%@ %@", response, responseObject);
           //[SDWebImageManager.sharedManager.imageCache clearMemory] ;
            
            contacts = (NSMutableArray*) responseObject[@"results"];
            NSString *query;
            int count=(int)contacts.count;
            NSString *queryDelete = [NSString stringWithFormat:@"delete from movieTopRated"];
            [self.dbManager executeQuery:queryDelete];
            
            for(int i=0; i<count; i++){
                NSDictionary *dict =(NSDictionary *)contacts[i];
                query = [NSString stringWithFormat:@"insert into movieTopRated(movieInfoID,mid ,title, poster_path ,backdrop_path,original_title ,overview,release_date, vote_average) values(null, \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\",\"%@\")",[dict objectForKey: @"id"], [dict objectForKey: @"title"], [dict objectForKey: @"poster_path"], [dict objectForKey: @"backdrop_path"], [dict objectForKey: @"original_title"], [dict objectForKey: @"overview"], [dict objectForKey: @"release_date"], [dict objectForKey: @"vote_average"]];
                [self.dbManager executeQuery:query];
                
                // If the query was successfully executed then pop the view controller.
                if (self.dbManager.affectedRows != 0) {
                    NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
                }
                else{
                    NSLog(@"Could not execute the query.");
                }
                
            }
            
        }
    }];
    [dataTask resume];
    [self loadData:querySelect];
}

-(void)loadData:(NSString*)query{
    
    // Get the results.
    if (self.arrmovieInfo != nil) {
        self.arrmovieInfo = nil;
    }
    self.arrmovieInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self->_myCollection reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numbOfRow=_arrmovieInfo.count;
    
    return numbOfRow;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImageView *img=[cell viewWithTag:2];
    NSString *imgUrl=@"http://image.tmdb.org/t/p/w185/";
    imgUrl = [imgUrl stringByAppendingString: [NSString stringWithFormat:@"%@", [[self.arrmovieInfo objectAtIndex:indexPath.row] objectAtIndex:3]]];
    
    [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imgUrl]]
           placeholderImage:[UIImage imageNamed:@"holderImg.png"]];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    movie.recordIDToEdit = [[[self.arrmovieInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    movie.favouriteOrNot=1;
    [self.navigationController pushViewController:movie animated:YES];
}

- (IBAction)indexChanged:(id)sender {
    NSURL *URLpopular;
    NSURL *URLtopRated;
    switch (_segmentControl.selectedSegmentIndex)
    {
    case 0:
    URLpopular= [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/popular?api_key=8b1cad7914e5aefb8190b0493bfae7a0"];
            [self getDataFromApi:URLpopular];
            movie.topRated=0;
            break;
        case 1:
     URLtopRated = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/top_rated?api_key=8b1cad7914e5aefb8190b0493bfae7a0"];
            [self getDataFromApiTopRated:URLtopRated];
            movie.topRated=1;
            
            break;
    default:
            break;
    }
}

@end

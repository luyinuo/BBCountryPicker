//
//  BBCountryPickerViewController.m
//  Bobby
//
//  Created by kevinlu on 2018/5/2.
//  Copyright © 2018年 BOBBY. All rights reserved.
//

#import "BBCountryPickerViewController.h"

@interface BBCountryPickerViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *displayController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL isSearched;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSMutableArray *searchResults;
@end

@implementation BBCountryPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Select Region", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackAction:)];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    NSString *plistName = @"";
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"myLanguage"];
    if ([language isEqualToString:@"en"]) {
        plistName = @"Country_en";
    }else{
        plistName = @"Country_zh";
    }
    NSDictionary *dataSource = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"]];

    NSArray *keysArray = [dataSource allKeys];
    keysArray = [keysArray sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    self.sectionTitles = keysArray;
    self.dataSource = [NSMutableArray array];
    for (NSString *key in keysArray) {
        [self.dataSource addObject:dataSource[key]];
    }
//    self.tableView.sectionIndexColor = [UIColor colorWithHexString:@"212121"];
    [self.tableView reloadData];
}

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}
NSInteger nickNameSort(id obj1, id obj2, void *context)
{
    return  [[obj1 objectForKey:@"Name"] localizedCompare:[obj2 objectForKey:@"Name"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onBackAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.tableView) {
        self.isSearched = NO;
        return self.sectionTitles.count;
    }else{
        self.isSearched = YES;
        return 1;
    }
}
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.tableView != tableView) {
        return nil;
    }
    return self.sectionTitles[section];
}
/*
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.tableView != tableView) {
        return nil;
    }
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    UILabel *titleHeader = [UILabel new];
    titleHeader.font = [UIFont systemFontOfSize:16];
    titleHeader.textColor = [UIColor colorWithHexString:@"666666"];
    titleHeader.text = self.sectionTitles[section];
    [headerView addSubview:titleHeader];
    [titleHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.bottom.right.equalTo(headerView);
    }];
    
    return headerView;
}
 */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView != self.tableView) {
        return self.searchResults.count;
    }
    return [self.dataSource[section] count];
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.tableView != tableView) {
        return nil;
    }
    return self.sectionTitles;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSInteger count = 0;
    
    for (NSString *character in self.sectionTitles) {
        
        if ([[character uppercaseString] hasPrefix:title]) {
            return count;
        }
        count++;
    }
    return  0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    if (tableView == self.tableView) {
        NSDictionary *dic = self.dataSource[indexPath.section][indexPath.row];
        cell.textLabel.text = dic[@"Name"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"+%@",dic[@"Number"]];
//        cell.textLabel.textColor = [UIColor colorWithHexString:@"212121"];
//        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }else{
        NSDictionary *dic = self.searchResults[indexPath.row];
        cell.textLabel.text = dic[@"Name"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"+%@",dic[@"Number"]];
    }
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.dataSource[indexPath.section][indexPath.row];
    BBCountryModel *model = [BBCountryModel modelWithDic:dic];
    if ([self.delegate respondsToSelector:@selector(didSelectedCountry:)]) {
        [self.delegate didSelectedCountry:model];
    }
    [self onBackAction:nil];
}
#pragma mark UISearchBar and UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name contains[cd]%@",searchString];
    self.searchResults = [NSMutableArray array];
    for (NSArray *subArray in self.dataSource) {
        [self.searchResults addObjectsFromArray:[subArray filteredArrayUsingPredicate:predicate]];
    }
    
    return YES;
}


@end
